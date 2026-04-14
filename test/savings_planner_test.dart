import 'package:flutter_test/flutter_test.dart';

import 'package:finance/domain/usecases/calculate_savings_plan.dart';

void main() {
  group('Savings Planner (TDD)', () {
    test('calculates months to reach target given monthly contribution', () {
      final params = SavingsPlanParams(targetAmount: 120000.0, monthlyContribution: 10000.0);
      final usecase = CalculateSavingsPlan();
      final plan = usecase.execute(params);

      expect(plan.monthsRequired, 12);
      expect((plan.monthlyContribution - 10000.0).abs() < 0.01, true);
    });

    test('calculates required monthly contribution if months fixed', () {
      final params = SavingsPlanParams(targetAmount: 60000.0, months: 6);
      final usecase = CalculateSavingsPlan();
      final plan = usecase.execute(params);

      expect(plan.monthlyContribution, 10000.0);
    });
  });
}
