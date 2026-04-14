import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance/data/repositories/transaction_repository_impl.dart';
import 'package:finance/data/datasources/local/hive_local_source.dart';
import 'package:finance/data/models/transaction_model.dart';
import 'package:finance/domain/entities/transaction.dart' as domain;

class MockHiveLocalSource extends Mock implements HiveLocalSource {}

class FakeTransactionModel extends Fake implements TransactionModel {}

void main() {
  group('TransactionRepositoryImpl', () {
    late MockHiveLocalSource mockLocal;
    late TransactionRepositoryImpl repo;

    setUpAll(() {
      registerFallbackValue(FakeTransactionModel());
    });

    setUp(() {
      mockLocal = MockHiveLocalSource();
      repo = TransactionRepositoryImpl(mockLocal);
    });

    test('addTransaction stores and returns domain transaction', () async {
      final tx = domain.Transaction(id: 't1', amount: 100.0, currency: 'KZT', timestamp: DateTime.now(), description: 'test');
  when(() => mockLocal.init()).thenAnswer((_) async {});
      when(() => mockLocal.putTransaction(any())).thenAnswer((_) async {});

      final res = await repo.addTransaction(tx);

      expect(res.id, tx.id);
      final captured = verify(() => mockLocal.putTransaction(captureAny())).captured;
      expect(captured, isNotEmpty);
      final passed = captured.first as TransactionModel;
      expect(passed.pendingSync, isTrue);
      // domain object returned should also reflect pendingSync
      expect(res.pendingSync, isTrue);
    });

    test('markSynced updates pending flag and getPendingTransactions returns only pending', () async {
      final now = DateTime.now();
      final txPending = domain.Transaction(id: 'p1', amount: 50.0, currency: 'KZT', timestamp: now, description: 'pending',);
      final mPending = TransactionModel.fromDomain(txPending, pendingSyncOverride: true);

      when(() => mockLocal.init()).thenAnswer((_) async {});
      when(() => mockLocal.getAllTransactions()).thenAnswer((_) async => [mPending]);
      when(() => mockLocal.putTransaction(any())).thenAnswer((_) async {});

      // getPendingTransactions should return the pending one
      final pending = await repo.getPendingTransactions();
      expect(pending.length, 1);
      expect(pending.first.id, 'p1');

      // markSynced should call putTransaction with pendingSync = false
      await repo.markSynced('p1');
      final captured = verify(() => mockLocal.putTransaction(captureAny())).captured;
      expect(captured, isNotEmpty);
      final updated = captured.last as TransactionModel;
      expect(updated.pendingSync, isFalse);
    });

    test('getTransactions returns filtered list', () async {
      final now = DateTime.now();
      final tx1 = domain.Transaction(id: 't1', amount: 100.0, currency: 'KZT', timestamp: now.subtract(Duration(days: 10)), description: 'old');
      final tx2 = domain.Transaction(id: 't2', amount: 200.0, currency: 'KZT', timestamp: now, description: 'new');

      final m1 = TransactionModel.fromDomain(tx1);
      final m2 = TransactionModel.fromDomain(tx2);

      when(() => mockLocal.init()).thenAnswer((_) async {});
      when(() => mockLocal.getAllTransactions()).thenAnswer((_) async => [m1, m2]);

      final resAll = await repo.getTransactions();
      expect(resAll.length, 2);

      final resFiltered = await repo.getTransactions(from: now.subtract(Duration(days: 1)));
      expect(resFiltered.length, 1);
      expect(resFiltered.first.id, 't2');
    });

    test('deleteTransaction calls local delete', () async {
      when(() => mockLocal.init()).thenAnswer((_) async {});
      when(() => mockLocal.deleteTransaction('t1')).thenAnswer((_) async {});

      await repo.deleteTransaction('t1');

      verify(() => mockLocal.deleteTransaction('t1')).called(1);
    });

    test('processSyncQueue uses uploader and marks synced when uploader returns true', () async {
      final now = DateTime.now();
      final txPending = domain.Transaction(id: 'q1', amount: 10.0, currency: 'KZT', timestamp: now, description: 'q');
      final mPending = TransactionModel.fromDomain(txPending, pendingSyncOverride: true);

      when(() => mockLocal.init()).thenAnswer((_) async {});
      when(() => mockLocal.getAllTransactions()).thenAnswer((_) async => [mPending]);
      when(() => mockLocal.putTransaction(any())).thenAnswer((_) async {});

      var calls = 0;
      Future<bool> uploader(domain.Transaction _) async {
        calls++;
        return Future.value(true);
      }

      await repo.processSyncQueue(uploader, maxRetries: 2, initialDelay: Duration(milliseconds: 1));

      expect(calls, equals(1));
      final captured = verify(() => mockLocal.putTransaction(captureAny())).captured;
      // one for add/update markSynced
      expect(captured, isNotEmpty);
      final updated = captured.last as TransactionModel;
      expect(updated.pendingSync, isFalse);
    });
  });
}
