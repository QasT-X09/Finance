import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance/data/sync/sync_service.dart';
import 'package:finance/domain/entities/transaction.dart' as domain;
import 'package:finance/domain/repositories/transaction_repository.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group('SyncService', () {
    late MockTransactionRepository mockRepo;
    late SyncService service;

    setUp(() {
      mockRepo = MockTransactionRepository();
      service = SyncService(mockRepo);
    });

    test('retries uploader and marks synced on success', () async {
      final tx = domain.Transaction(id: 's1', amount: 10.0, currency: 'KZT', timestamp: DateTime.now(), description: 'x',);

      when(() => mockRepo.getPendingTransactions()).thenAnswer((_) async => [tx]);
      when(() => mockRepo.markSynced('s1')).thenAnswer((_) async {});

      var calls = 0;
      Future<bool> uploader(domain.Transaction _) async {
        calls++;
        if (calls < 3) return Future.value(false);
        return Future.value(true);
      }

      await service.processQueue(uploader, maxRetries: 4, initialDelay: Duration(milliseconds: 1));

      expect(calls, greaterThanOrEqualTo(3));
      verify(() => mockRepo.markSynced('s1')).called(1);
    });

    test('gives up after max retries and does not mark synced', () async {
      final tx = domain.Transaction(id: 's2', amount: 20.0, currency: 'KZT', timestamp: DateTime.now(), description: 'y',);

      when(() => mockRepo.getPendingTransactions()).thenAnswer((_) async => [tx]);
      when(() => mockRepo.markSynced(any())).thenAnswer((_) async {});

      var calls = 0;
      Future<bool> uploader(domain.Transaction _) async {
        calls++;
        return Future.value(false);
      }

      final maxRetries = 2;
      await service.processQueue(uploader, maxRetries: maxRetries, initialDelay: Duration(milliseconds: 1));

      // should attempt initial + retries
      expect(calls, equals(maxRetries + 1));
      verifyNever(() => mockRepo.markSynced('s2'));
    });
  });
}
