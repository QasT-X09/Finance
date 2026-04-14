import 'dart:async';

import 'package:finance/core/cancel_token.dart';
import 'package:finance/data/remote/remote_source.dart';
import 'package:finance/domain/entities/transaction.dart';
import 'package:finance/domain/repositories/transaction_repository.dart';

class SyncResult {
  final List<String> successIds;
  final List<String> failedIds;

  SyncResult({required this.successIds, required this.failedIds});
}

typedef ProgressCallback = void Function(int done, int total);

class SyncService {
  final TransactionRepository _repo;
  final RemoteSource _remote;

  SyncService(this._repo, this._remote);

  /// Uploads [items] with limited concurrency. Reports progress via [onProgress].
  Future<SyncResult> uploadBatch(List<Transaction> items, {int concurrency = 3, CancelToken? cancelToken, ProgressCallback? onProgress}) async {
    final queue = List<Transaction>.from(items);
    final success = <String>[];
    final failed = <String>[];
    var done = 0;
    final workers = <Future>[];

    for (var i = 0; i < concurrency; i++) {
      workers.add(Future(() async {
        while (true) {
          if (cancelToken?.isCancelled ?? false) break;
          if (queue.isEmpty) break;
          final tx = queue.removeAt(0);
          final ok = await _remote.uploadTransaction(tx, cancelToken: cancelToken);
          if (ok) {
            await _repo.markSynced(tx.id);
            success.add(tx.id);
          } else {
            failed.add(tx.id);
          }
          done += 1;
          try {
            onProgress?.call(done, items.length);
          } catch (_) {}
        }
      }));
    }

    await Future.wait(workers);
    return SyncResult(successIds: success, failedIds: failed);
  }
}
