import '../entities/insight.dart';

abstract class InsightRepository {
  Future<List<Insight>> getInsights({DateTime? from, DateTime? to});
  Future<void> addInsight(Insight insight);
}
