import 'dart:async';

/// Simple cancellation token that can be passed to async operations.
class CancelToken {
  final Completer<void> _c = Completer<void>();

  /// Mark the token as cancelled. Subsequent checks or awaiters will observe cancellation.
  void cancel() {
    if (!_c.isCompleted) _c.complete();
  }

  /// Future that completes when cancelled.
  Future<void> get whenCancelled => _c.future;

  /// Whether cancellation was requested.
  bool get isCancelled => _c.isCompleted;
}
