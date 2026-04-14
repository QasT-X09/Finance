import 'package:finance/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders fintech dashboard core sections', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: FinanceApp()));
    await tester.pumpAndSettle();

    expect(find.text('Hello, Alex!'), findsOneWidget);
    expect(find.text('Total Balance'), findsOneWidget);
    expect(find.text('Recent recipients'), findsOneWidget);
    expect(find.text('Savings goals'), findsOneWidget);
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Spend'), findsOneWidget);
  });

  testWidgets('navigates with bottom bar to wallet and exchange screens', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: FinanceApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Wallet'));
    await tester.pumpAndSettle();
    expect(find.text('My Wallet'), findsOneWidget);

    await tester.tap(find.text('Exchange'));
    await tester.pumpAndSettle();
    expect(find.text('Currency Exchange'), findsOneWidget);
  });
}
