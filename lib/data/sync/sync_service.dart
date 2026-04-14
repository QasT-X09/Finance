import 'dart:async';
import 'dart:math';

import 'package:finance/domain/entities/transaction.dart' as domain;
import 'package:finance/domain/repositories/transaction_repository.dart';

class SyncService {
  final TransactionRepository _repo;

  SyncService(this._repo);

  /// Processes pending transactions using [uploader].
  /// For each pending transaction, will attempt up to [maxRetries] retries.
  /// [initialDelay] is used for exponential backoff base.
  Future<void> processQueue(
    Future<bool> Function(domain.Transaction tx) uploader, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(milliseconds: 200),
  }) async {
    final pending = await _repo.getPendingTransactions();
    for (final tx in pending) {
      var attempt = 0;
      var success = false;
      while (attempt <= maxRetries && !success) {
        try {
          final ok = await uploader(tx);
          if (ok) {
            await _repo.markSynced(tx.id);
            success = true;
            break;
          }
        } catch (_) {
          // swallow and retry
        }

        if (!success) {
          if (attempt >= maxRetries) break;
          final backoffMs = (initialDelay.inMilliseconds * pow(2, attempt)).toInt();
          await Future.delayed(Duration(milliseconds: backoffMs));
          attempt++;
        }
      }
    }
  }
}
