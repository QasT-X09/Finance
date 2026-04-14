import 'package:flutter_test/flutter_test.dart';
import 'package:finance/core/cancel_token.dart';

void main() {
  test('CancelToken completes when cancelled and isCancelled flips', () async {
    final t = CancelToken();
    var completed = false;
    t.whenCancelled.then((_) {
      completed = true;
    });

    expect(t.isCancelled, isFalse);
    t.cancel();
    // allow microtask events
    await Future<void>.delayed(Duration(milliseconds: 1));
    expect(t.isCancelled, isTrue);
    expect(completed, isTrue);
  });
}
