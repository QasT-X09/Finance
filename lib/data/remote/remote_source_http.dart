import 'dart:convert';
import 'dart:io';

import 'package:finance/data/remote/remote_source.dart';
import 'package:finance/domain/entities/transaction.dart' as domain;
import 'package:finance/core/cancel_token.dart';

/// Minimal HTTP RemoteSource using dart:io HttpClient.
/// Reads endpoint and token from provided constructor or environment.
class RemoteSourceHttp implements RemoteSource {
  final Uri endpoint;
  final Duration timeout;
  final String? authToken;
  final HttpClient _client;

  RemoteSourceHttp({required this.endpoint, Duration? timeout, this.authToken, HttpClient? client})
      : timeout = timeout ?? const Duration(seconds: 5),
        _client = client ?? HttpClient();

  HttpClient get client => _client;

  @override
  Future<bool> uploadTransaction(domain.Transaction tx, {CancelToken? cancelToken}) async {
    try {
      final req = await _client.postUrl(endpoint).timeout(timeout);
      req.headers.contentType = ContentType.json;
      if (authToken != null) {
        req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $authToken');
      }
      final body = jsonEncode({
        'id': tx.id,
        'amount': tx.amount,
        'currency': tx.currency,
        'timestamp': tx.timestamp.toIso8601String(),
        'description': tx.description,
        'metadata': tx.metadata,
      });
      req.write(body);

      // If a cancelToken is provided, attach a listener to abort the request early
      if (cancelToken != null) {
        // Attach best-effort cancellation: when token completes, call abort on request
        // fire-and-forget: when cancelled, attempt to abort request
        cancelToken.whenCancelled.then((_) {
          try {
            req.abort();
          } catch (_) {}
        });

        final closeFuture = req.close();
        final res = await Future.any([closeFuture, cancelToken.whenCancelled]);
        if (cancelToken.isCancelled) {
          // Already attempted abort via listener above; just return false
          return false;
        }
        final resp = res as HttpClientResponse;
        final code = resp.statusCode;
        return code >= 200 && code < 300;
      } else {
        final resp = await req.close().timeout(timeout);
        final code = resp.statusCode;
        return code >= 200 && code < 300;
      }
    } catch (_) {
      return false;
    }
  }
}
