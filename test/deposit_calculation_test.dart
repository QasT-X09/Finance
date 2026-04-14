import 'dart:math';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance/domain/usecases/calculate_deposit.dart';

void main() {
  group('Deposit calculation (TDD)', () {
    test('monthly compounding yields expected future value', () {
      final params = CalculateDepositParams(
        principal: 10000.0,
        annualRatePercent: 12.0,
        months: 12,
        compounding: Compounding.monthly,
      );

      final usecase = CalculateDeposit();
      final projection = usecase.execute(params);

      // Expected: FV = P * (1 + r/12)^12
      final r = 0.12;
      final expected = 10000.0 * pow(1 + r / 12, 12);

      expect((projection.futureValue - expected).abs() < 0.01, true);
    });
  });
}
