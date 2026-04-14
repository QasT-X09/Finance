import 'package:flutter_test/flutter_test.dart';

import 'package:finance/domain/engines/decision_engine.dart';
import 'package:finance/domain/entities/transaction.dart';

void main() {
  group('DecisionEngine (TDD)', () {
    test('detects overspending and generates recommendation', () {
      // previous period: food total 10000
      final prev = [
        Transaction(id: 'p1', amount: 4000.0, currency: 'KZT', timestamp: DateTime(2026,3,1), description: 'еда'),
        Transaction(id: 'p2', amount: 6000.0, currency: 'KZT', timestamp: DateTime(2026,3,5), description: 'еда'),
      ];

      // current period: food total 12700 (+27%)
      final curr = [
        Transaction(id: 'c1', amount: 5000.0, currency: 'KZT', timestamp: DateTime(2026,4,1), description: 'еда'),
        Transaction(id: 'c2', amount: 7700.0, currency: 'KZT', timestamp: DateTime(2026,4,3), description: 'еда'),
      ];

      final engine = DecisionEngine();
      final insights = engine.generateInsights(prevTransactions: prev, currentTransactions: curr);

  expect(insights, isNotEmpty);
  final match = insights.any((i) => i.description.contains('27') || i.description.contains('Изменение'));
  expect(match, true);
    });
  });
}
