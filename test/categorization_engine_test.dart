import 'package:flutter_test/flutter_test.dart';

// TDD: tests reference domain interfaces that will be implemented later.
import 'package:finance/domain/engines/categorization_engine.dart';
import 'package:finance/domain/entities/transaction.dart';
import 'package:finance/domain/entities/category.dart';

void main() {
  group('CategorizationEngine (TDD)', () {
    test('assigns category by keyword match (рус/eng)', () {
      // arrange
      final tx = Transaction(
        id: 't1',
        amount: 3500.0,
        currency: 'KZT',
        timestamp: DateTime.parse('2026-04-01T12:00:00'),
        description: 'Покупка: Магазин, еда, 3500',
      );

      final engine = CategorizationEngine(rules: [
        CategorizationRule(categoryId: 'food', keywords: ['еда', 'food', 'restaurant', 'кафе'], priority: 10),
      ]);

      // act
      final category = engine.categorize(tx);

      // assert
      expect(category, isA<Category>());
      expect(category.id, 'food');
  final lowerName = category.name.toLowerCase();
  expect(lowerName.contains('food') || lowerName.contains('еда'), true);
    });

    test('falls back to uncategorized when no rule matches', () {
      final tx = Transaction(
        id: 't2',
        amount: 1200.0,
        currency: 'KZT',
        timestamp: DateTime.now(),
        description: 'Неизвестная операция XYZ',
      );
      final engine = CategorizationEngine(rules: [CategorizationRule(categoryId: 'food', keywords: ['еда'])]);
      final category = engine.categorize(tx);

      expect(category.id, 'uncategorized');
    });

    test('parses Kaspi notification and maps to kaspi category', () {
      final tx = Transaction(
        id: 'k1',
        amount: 3500.0,
        currency: 'KZT',
        timestamp: DateTime.now(),
        description: 'Kaspi: Покупка 3500₸ Magnum',
      );

      final engine = CategorizationEngine(rules: [
        CategorizationRule(categoryId: 'kaspi', merchants: ['kaspi'], priority: 20),
        CategorizationRule(categoryId: 'food', keywords: ['еда', 'restaurant'], priority: 5),
      ]);

      final c = engine.categorize(tx);
      expect(c.id, 'kaspi');
    });

    test('detects installment/рассрочка by pattern', () {
      final tx = Transaction(
        id: 'r1',
        amount: 50000.0,
        currency: 'KZT',
        timestamp: DateTime.now(),
        description: 'Рассрочка: платеж 1/12',
      );

      final engine = CategorizationEngine(rules: [
        CategorizationRule(categoryId: 'installment', patterns: [RegExp(r'рассроч', caseSensitive: false)], priority: 15),
      ]);

      final c = engine.categorize(tx);
      expect(c.id, 'installment');
    });

    test('detects transfer by keyword', () {
      final tx = Transaction(
        id: 'tr1',
        amount: 200000.0,
        currency: 'KZT',
        timestamp: DateTime.now(),
        description: 'Перевод на карту 1234',
      );

      final engine = CategorizationEngine(rules: [
        CategorizationRule(categoryId: 'transfer', keywords: ['перевод', 'transfer'], priority: 8),
      ]);

      final c = engine.categorize(tx);
      expect(c.id, 'transfer');
    });
  });
}
