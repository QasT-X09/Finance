import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions({DateTime? from, DateTime? to});
  Future<Transaction> addTransaction(Transaction tx);
  Future<void> updateTransaction(Transaction tx);
  Future<void> deleteTransaction(String id);
  Stream<List<Transaction>> watchTransactions({DateTime? from, DateTime? to});
  Future<void> markSynced(String id);
  Future<List<Transaction>> getPendingTransactions();
  Future<void> processSyncQueue(Future<bool> Function(Transaction tx) uploader, {int maxRetries, Duration? initialDelay});
}
