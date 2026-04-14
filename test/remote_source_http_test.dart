import 'dart:io';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:finance/data/remote/remote_source_http.dart';
import 'package:finance/domain/entities/transaction.dart' as domain;

void main() {
  test('uploadTransaction returns true on 200', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((HttpRequest req) async {
      // read body
      await utf8.decoder.bind(req).join();
      req.response.statusCode = 200;
      await req.response.close();
    });

    final uri = Uri.parse('http://${server.address.address}:${server.port}/upload');
    final http = RemoteSourceHttp(endpoint: uri);

    final tx = domain.Transaction(id: 't1', amount: 1.0, currency: 'KZT', timestamp: DateTime.now(), description: 'x');
    final ok = await http.uploadTransaction(tx);
    expect(ok, isTrue);

    await server.close(force: true);
  });

  test('uploadTransaction returns false on 500', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((HttpRequest req) async {
      await utf8.decoder.bind(req).join();
      req.response.statusCode = 500;
      await req.response.close();
    });

    final uri = Uri.parse('http://${server.address.address}:${server.port}/upload');
    final http = RemoteSourceHttp(endpoint: uri);

    final tx = domain.Transaction(id: 't2', amount: 2.0, currency: 'KZT', timestamp: DateTime.now(), description: 'y');
    final ok = await http.uploadTransaction(tx);
    expect(ok, isFalse);

    await server.close(force: true);
  });
}
