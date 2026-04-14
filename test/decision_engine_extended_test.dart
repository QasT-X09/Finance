import 'package:flutter_test/flutter_test.dart';
import 'package:finance/domain/engines/decision_engine.dart';
import 'package:finance/domain/entities/transaction.dart';

void main() {
  group('DecisionEngine extended (TDD)', () {
    test('detects category spike (27%)', () {
      final prev = [
        Transaction(id: 'p1', amount: 4000.0, currency: 'KZT', timestamp: DateTime(2026,3,1), description: 'еда'),
        Transaction(id: 'p2', amount: 6000.0, currency: 'KZT', timestamp: DateTime(2026,3,5), description: 'еда'),
      ];

      final curr = [
        Transaction(id: 'c1', amount: 5000.0, currency: 'KZT', timestamp: DateTime(2026,4,1), description: 'еда'),
        Transaction(id: 'c2', amount: 7700.0, currency: 'KZT', timestamp: DateTime(2026,4,3), description: 'еда'),
      ];

      final engine = DecisionEngine();
      final insights = engine.generateInsights(prevTransactions: prev, currentTransactions: curr);

      final has = insights.any((i) => i.id.startsWith('delta_') && i.description.contains('27'));
      expect(has, true);
    });

    test('detects recurring payments', () {
      final txs = [
        Transaction(id: 't1', amount: 1000.0, currency: 'KZT', timestamp: DateTime(2026,1,5), description: 'Spotify оплата'),
        Transaction(id: 't2', amount: 1000.0, currency: 'KZT', timestamp: DateTime(2026,2,5), description: 'Spotify оплата'),
        Transaction(id: 't3', amount: 1000.0, currency: 'KZT', timestamp: DateTime(2026,3,5), description: 'Spotify оплата'),
      ];

      final engine = DecisionEngine();
      final insights = engine.generateInsights(prevTransactions: [], currentTransactions: txs);

      final recurring = insights.any((i) => i.id.startsWith('recurring_') && i.title.contains('Повторяющаяся'));
      expect(recurring, true);
    });
  });
}
