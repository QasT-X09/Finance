import '../entities/transaction.dart';
import '../entities/insight.dart';

class DecisionEngine {
  DecisionEngine();

  /// Generate insights by comparing aggregates per category and simple behavioral rules.
  List<Insight> generateInsights({required List<Transaction> prevTransactions, required List<Transaction> currentTransactions}) {
    final insights = <Insight>[];

    // Helper to determine category: prefer explicit categoryId, else fallback to keyword mapping
    String categoryOf(Transaction t) {
      if (t.categoryId != null && t.categoryId!.isNotEmpty) return t.categoryId!;
      final text = t.description.toLowerCase();
      if (text.contains('еда') || text.contains('restaurant') || text.contains('кафе')) return 'food';
      if (text.contains('перевод') || text.contains('transfer')) return 'transfer';
      if (text.contains('рассроч') || text.contains('install')) return 'installment';
      if (text.contains('kaspi')) return 'kaspi';
      return 'uncategorized';
    }

    Map<String, double> sumPrev = {};
    Map<String, double> sumCurr = {};

    for (final t in prevTransactions) {
      final c = categoryOf(t);
      sumPrev[c] = (sumPrev[c] ?? 0) + t.amount;
    }
    for (final t in currentTransactions) {
      final c = categoryOf(t);
      sumCurr[c] = (sumCurr[c] ?? 0) + t.amount;
    }

    // Compare categories present in either period
    final categories = <String>{...sumPrev.keys, ...sumCurr.keys};
    for (final c in categories) {
      final prev = sumPrev[c] ?? 0.0;
      final curr = sumCurr[c] ?? 0.0;

      if (prev > 0) {
        final change = (curr - prev) / prev;
        final percent = (change * 100).round();
        if (change.abs() >= 0.1) {
          final severity = (change >= 0.3) ? 'high' : 'medium';
          final title = change > 0 ? 'Рост трат в категории $c' : 'Снижение трат в категории $c';
          insights.add(Insight(id: 'delta_$c', title: title, description: 'Изменение: $percent% ($severity)', score: change));
        }
      } else if (curr > 0 && prev == 0) {
        // new category spending
        insights.add(Insight(id: 'new_spend_$c', title: 'Новые траты в $c', description: 'Вы начали тратить в категории $c: ${curr.toStringAsFixed(0)}'));
      }
    }

    // Recurring expense detection: find descriptions that repeat
  final all = <Transaction>[...prevTransactions, ...currentTransactions];
    final Map<String, List<Transaction>> groups = {};
    for (final t in all) {
      final key = _normalizeMerchant(t.description);
      groups.putIfAbsent(key, () => []).add(t);
    }

    for (final entry in groups.entries) {
      final key = entry.key;
      final list = entry.value;
      if (list.length >= 3) {
        // consider recurring
        insights.add(Insight(id: 'recurring_$key', title: 'Повторяющаяся подписка', description: 'Обнаружены повторяющиеся траты: $key', score: null));
      }
    }

    return insights;
  }

  String _normalizeMerchant(String s) {
    final low = s.toLowerCase();
    final cleaned = low.replaceAll(RegExp(r'\d+'), '').replaceAll(RegExp(r'[^a-zа-яё]+'), ' ').trim();
    return cleaned.split(' ').where((p) => p.length > 2).join(' ');
  }
}
