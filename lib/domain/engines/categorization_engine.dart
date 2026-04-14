import '../entities/transaction.dart';
import '../entities/category.dart';

/// Rule for categorization. Priority: higher value = higher priority.
class CategorizationRule {
  final String categoryId;
  final List<String> keywords;
  final List<RegExp> patterns;
  final List<String> merchants;
  final int priority;

  CategorizationRule({
    required this.categoryId,
    this.keywords = const [],
    this.patterns = const [],
    this.merchants = const [],
    this.priority = 0,
  });
}

class CategorizationEngine {
  final List<CategorizationRule> rules;

  CategorizationEngine({List<CategorizationRule>? rules}) : rules = (rules ?? [])..sort((a, b) => b.priority.compareTo(a.priority));

  Category categorize(Transaction tx) {
    final text = tx.description.toLowerCase();

    for (final rule in rules) {
      // merchant match
      for (final m in rule.merchants) {
        if (text.contains(m.toLowerCase())) {
          return Category(id: rule.categoryId, name: rule.categoryId);
        }
      }

      // keyword match
      for (final kw in rule.keywords) {
        if (text.contains(kw.toLowerCase())) {
          return Category(id: rule.categoryId, name: rule.categoryId);
        }
      }

      // regex patterns
      for (final p in rule.patterns) {
        if (p.hasMatch(tx.description)) {
          return Category(id: rule.categoryId, name: rule.categoryId);
        }
      }
    }

    return Category(id: 'uncategorized', name: 'Uncategorized');
  }
}
