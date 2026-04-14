import 'dart:math';

enum Compounding { monthly, annually }

class CalculateDepositParams {
  final double principal;
  final double annualRatePercent;
  final int months;
  final Compounding compounding;

  CalculateDepositParams({required this.principal, required this.annualRatePercent, required this.months, this.compounding = Compounding.monthly});
}

class DepositProjection {
  final double futureValue;
  DepositProjection(this.futureValue);
}

class CalculateDeposit {
  CalculateDeposit();

  DepositProjection execute(CalculateDepositParams p) {
    final r = p.annualRatePercent / 100.0;
    if (p.compounding == Compounding.monthly) {
      final periods = p.months;
      final monthlyRate = r / 12.0;
      final fv = p.principal * pow(1 + monthlyRate, periods);
      return DepositProjection(fv.toDouble());
    } else {
      final years = p.months / 12.0;
      final fv = p.principal * pow(1 + r, years);
      return DepositProjection(fv.toDouble());
    }
  }
}
