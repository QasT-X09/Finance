import 'dart:async';

import 'package:finance/data/remote/remote_source.dart';
import 'package:finance/domain/entities/transaction.dart' as domain;
import 'package:finance/core/cancel_token.dart';

/// Simple stub that simulates a remote upload with optional delay and failure rate.
class RemoteSourceStub implements RemoteSource {
  final Duration delay;
  final double failureRate; // 0.0..1.0

  RemoteSourceStub({this.delay = const Duration(milliseconds: 50), this.failureRate = 0.0});

  @override
  Future<bool> uploadTransaction(domain.Transaction tx, {CancelToken? cancelToken}) async {
    final d = Future.delayed(delay);
    if (cancelToken != null) {
      await Future.any([d, cancelToken.whenCancelled]);
      if (cancelToken.isCancelled) return false;
    } else {
      await d;
    }
    if (failureRate <= 0) return true;
    final r = DateTime.now().millisecondsSinceEpoch % 100 / 100.0;
    return r >= failureRate;
  }
}
