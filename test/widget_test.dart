// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// no direct material imports required for this widget test
import 'package:flutter_test/flutter_test.dart';

import 'package:finance/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  // Build our app and trigger a frame.
  await tester.pumpWidget(const ProviderScope(child: FinanceApp()));

  // Verify that app shows title and balance card.
  expect(find.text('Smart Finance Coach'), findsOneWidget);
  expect(find.text('Balance'), findsOneWidget);
  });
}
