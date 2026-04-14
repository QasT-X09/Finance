import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  Future<List<Transaction>> execute({DateTime? from, DateTime? to}) async {
    return await repository.getTransactions(from: from, to: to);
  }
}
