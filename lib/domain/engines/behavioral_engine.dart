import '../entities/transaction.dart';
import '../entities/insight.dart';

class BehavioralEngine {
  BehavioralEngine();

  /// Analyze transactions for behavioral patterns.
  /// Returns insights: night spending, impulsive clusters, weekday/weekend skew.
  List<Insight> analyze(List<Transaction> transactions) {
    final insights = <Insight>[];
    if (transactions.isEmpty) return insights;

    // NIGHT SPENDING
    final night = transactions.where((t) => t.timestamp.hour >= 0 && t.timestamp.hour < 6).toList();
    if (night.isNotEmpty) {
      insights.add(Insight(
        id: 'night_spending',
        title: 'Ночные траты',
        description: 'Обнаружены траты в ночное время (00:00–06:00). Это может быть импульсивно.',
        score: (night.length / transactions.length),
      ));
    }

    // IMPULSIVE / CLUSTERED SMALL PURCHASES
    // Define small amount threshold and time window
    const smallThreshold = 2000.0; // KZT
    const windowHours = 2;
    // sort by timestamp
    final sorted = List<Transaction>.from(transactions)..sort((a, b) => a.timestamp.compareTo(b.timestamp));

  // bool foundImpulsive not used, we break on first cluster found
    for (var i = 0; i < sorted.length; i++) {
      final start = sorted[i].timestamp;
      final cluster = <Transaction>[];
      for (var j = i; j < sorted.length; j++) {
        final t = sorted[j];
        if (t.timestamp.difference(start).inHours <= windowHours && t.amount <= smallThreshold) {
          cluster.add(t);
        }
      }
      if (cluster.length >= 3) {
        insights.add(Insight(
          id: 'impulsive_cluster',
          title: 'Импульсивные покупки',
          description: 'Найден кластер мелких расходов (${cluster.length}) в пределах $windowHours часов. Это может указывать на импульсивное поведение.',
          score: cluster.length.toDouble(),
        ));
        break;
      }
    }

    // WEEKDAY vs WEEKEND PATTERNS
    double weekdaySum = 0.0;
    double weekendSum = 0.0;
    for (final t in transactions) {
      final wd = t.timestamp.weekday; // 1..7 (Mon..Sun)
      if (wd == DateTime.saturday || wd == DateTime.sunday) {
        weekendSum += t.amount;
      } else {
        weekdaySum += t.amount;
      }
    }
    final total = weekdaySum + weekendSum;
    if (total > 0) {
      final weekendShare = weekendSum / total;
      if (weekendShare > 0.6) {
        insights.add(Insight(
          id: 'weekend_spending',
          title: 'Склонность тратить в выходные',
          description: 'Большая часть трат (${(weekendShare * 100).round()}%) приходится на выходные дни.',
          score: weekendShare,
        ));
      } else if (weekendShare < 0.2) {
        insights.add(Insight(
          id: 'weekday_skew',
          title: 'Траты в будни',
          description: 'Большая часть трат приходится на будние дни.',
          score: 1 - weekendShare,
        ));
      }
    }

    return insights;
  }
}

