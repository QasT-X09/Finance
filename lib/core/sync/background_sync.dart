import 'dart:async';

import 'package:finance/domain/repositories/transaction_repository.dart';
import 'package:finance/data/remote/remote_source.dart';
// domain.Transaction not directly referenced here; repo/remote use it.

/// In-app background sync service. For now it runs a Timer while the app
/// is alive to periodically call repository.processSyncQueue. This is a
/// lightweight stub for demonstration and should be replaced with a
/// platform-specific background scheduler (WorkManager / BGTask) for
/// production.
class BackgroundSyncService {
  final TransactionRepository _repo;
  final RemoteSource _remote;
  Timer? _timer;
  // observable flag to indicate active syncing state
  final StreamController<bool> _syncingController = StreamController<bool>.broadcast();

  Stream<bool> get syncing => _syncingController.stream;

  BackgroundSyncService(this._repo, this._remote);

  void start({Duration interval = const Duration(minutes: 15)}) {
    stop();
    _timer = Timer.periodic(interval, (_) async {
      try {
        _syncingController.add(true);
        await _repo.processSyncQueue(_remote.uploadTransaction, maxRetries: 3, initialDelay: Duration(milliseconds: 500));
        _syncingController.add(false);
      } catch (_) {
        // ignore errors here; retries happen in repo
        _syncingController.add(false);
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> triggerNow() async {
    try {
      _syncingController.add(true);
      await _repo.processSyncQueue(_remote.uploadTransaction, maxRetries: 3, initialDelay: Duration(milliseconds: 200));
    } finally {
      _syncingController.add(false);
    }
  }

  void dispose() => stop();

  void close() {
    _syncingController.add(false);
    _syncingController.close();
  }
}
