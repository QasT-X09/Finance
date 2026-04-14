import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:finance/domain/engines/simulation_engine.dart';

void main() {
  test('simulateSavings computes expected future value', () {
    final engine = SimulationEngine();
    final principal = 1000.0;
    final monthly = 100.0;
    final annualRate = 0.06; // 6%
    final months = 12;

    final result = engine.simulateSavings(principal: principal, monthlyContribution: monthly, annualRate: annualRate, months: months);

    final monthlyRate = annualRate / 12.0;
    final fvPrincipal = principal * pow(1 + monthlyRate, months);
    final fvContrib = monthly * (pow(1 + monthlyRate, months) - 1) / monthlyRate;
    final expected = fvPrincipal + fvContrib;

    expect(result, closeTo(expected, 0.01));
  });
}
