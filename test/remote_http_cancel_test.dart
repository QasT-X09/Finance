import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:finance/data/remote/remote_source_http.dart';
import 'package:finance/core/cancel_token.dart';
import 'package:finance/domain/entities/transaction.dart';

void main() {
  test('RemoteSourceHttp respects CancelToken and returns false', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((HttpRequest req) async {
      // consume request body slowly
      await for (var _ in req) {
        await Future.delayed(Duration(milliseconds: 50));
      }
      // delay response to simulate slow server
      await Future.delayed(Duration(milliseconds: 200));
      req.response.statusCode = 200;
      req.response.write(jsonEncode({'ok': true}));
      await req.response.close();
    });

    final uri = Uri.parse('http://${server.address.address}:${server.port}/');
    final remote = RemoteSourceHttp(endpoint: uri, timeout: Duration(seconds: 5));

    final tx = Transaction(
      id: 'h1',
      amount: 3.0,
      currency: 'USD',
      timestamp: DateTime.now(),
      description: 'http-cancel',
    );

    final token = CancelToken();
    final f = remote.uploadTransaction(tx, cancelToken: token);
    // cancel shortly after starting
    Future.delayed(Duration(milliseconds: 10), () => token.cancel());

    final ok = await f;
    expect(ok, isFalse);

    await server.close();
  });
}
