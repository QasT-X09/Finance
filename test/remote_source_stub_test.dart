import 'package:flutter_test/flutter_test.dart';
import 'package:finance/data/remote/remote_source_stub.dart';
import 'package:finance/domain/entities/transaction.dart' as domain;

void main() {
  test('RemoteSourceStub succeeds when failureRate=0', () async {
    final stub = RemoteSourceStub(delay: Duration(milliseconds: 1), failureRate: 0.0);
    final tx = domain.Transaction(id: 't1', amount: 1.0, currency: 'KZT', timestamp: DateTime.now(), description: 'x');
    final ok = await stub.uploadTransaction(tx);
    expect(ok, isTrue);
  });
}
