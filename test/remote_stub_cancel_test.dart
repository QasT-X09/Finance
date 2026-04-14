import 'package:flutter_test/flutter_test.dart';
import 'package:finance/data/remote/remote_source_stub.dart';
import 'package:finance/core/cancel_token.dart';
import 'package:finance/domain/entities/transaction.dart';

void main() {
  test('RemoteSourceStub returns false when cancelled before delay', () async {
    final stub = RemoteSourceStub(delay: Duration(milliseconds: 200));
    final token = CancelToken();
    final tx = Transaction(
      id: 't1',
      amount: 1.0,
      currency: 'USD',
      timestamp: DateTime.now(),
      description: 'x',
    );

    final f = stub.uploadTransaction(tx, cancelToken: token);
    // cancel quickly
    token.cancel();
    final ok = await f;
    expect(ok, isFalse);
  });

  test('RemoteSourceStub completes normally when not cancelled', () async {
    final stub = RemoteSourceStub(delay: Duration(milliseconds: 10));
    final tx = Transaction(
      id: 't2',
      amount: 2.0,
      currency: 'EUR',
      timestamp: DateTime.now(),
      description: 'y',
    );

    final ok = await stub.uploadTransaction(tx);
    expect(ok, isTrue);
  });
}
