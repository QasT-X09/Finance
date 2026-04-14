import 'package:flutter_test/flutter_test.dart';

import 'package:finance/domain/engines/behavioral_engine.dart';
import 'package:finance/domain/entities/transaction.dart';

void main() {
  group('BehavioralEngine (TDD)', () {
    test('detects night transactions', () {
      final tx = Transaction(
        id: 'n1',
        amount: 1500.0,
        currency: 'KZT',
        timestamp: DateTime.parse('2026-04-02T01:30:00'),
        description: 'Ночная покупка',
      );

      final engine = BehavioralEngine();
      final insights = engine.analyze([tx]);

      final hasNight = insights.any((i) => i.title.toLowerCase().contains('ночн'));
      expect(hasNight, true);
    });
  });
}
