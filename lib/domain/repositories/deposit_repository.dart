import '../entities/deposit.dart';

abstract class DepositRepository {
  Future<List<Deposit>> getDeposits();
  Future<Deposit> addDeposit(Deposit d);
}
