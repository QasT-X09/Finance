import 'package:flutter_test/flutter_test.dart';

import 'package:finance/domain/usecases/calculate_financial_score.dart';

void main() {
  group('Financial Score (TDD)', () {
    test('healthy vs unhealthy produces higher score for healthy behaviour', () {
      final healthy = FinancialScoreParams(
        savingsRate: 0.25,
        stabilityIndex: 0.9,
        impulsiveSpendingIndex: 0.05,
      );

      final unhealthy = FinancialScoreParams(
        savingsRate: 0.05,
        stabilityIndex: 0.4,
        impulsiveSpendingIndex: 0.4,
      );

      final usecase = CalculateFinancialScore();
      final healthyScore = usecase.execute(healthy);
      final unhealthyScore = usecase.execute(unhealthy);

      expect(healthyScore.value > unhealthyScore.value, true);
      expect(healthyScore.value >= 0 && healthyScore.value <= 100, true);
      expect(unhealthyScore.value >= 0 && unhealthyScore.value <= 100, true);
    });
  });
}
