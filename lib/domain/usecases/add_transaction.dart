import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  Future<Transaction> execute(Transaction tx) async {
    // validation could be added here
    return await repository.addTransaction(tx);
  }
}
