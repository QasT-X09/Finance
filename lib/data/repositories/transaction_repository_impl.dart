import 'dart:async';
import 'package:finance/domain/entities/transaction.dart' as domain;
import 'package:finance/domain/repositories/transaction_repository.dart';
import '../datasources/local/hive_local_source.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final HiveLocalSource _local;

  TransactionRepositoryImpl(this._local);

  @override
  Future<domain.Transaction> addTransaction(domain.Transaction tx) async {
    await _local.init();
    // Mark newly added local transactions as pending sync until they are uploaded
    final model = TransactionModel.fromDomain(tx, pendingSyncOverride: true);
    await _local.putTransaction(model);
    return model.toDomain();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _local.init();
    await _local.deleteTransaction(id);
  }

  @override
  Future<List<domain.Transaction>> getTransactions({DateTime? from, DateTime? to}) async {
    await _local.init();
    final models = await _local.getAllTransactions();
    var list = models.map((m) => m.toDomain()).toList();
    if (from != null) {
      list = list.where((t) => t.timestamp.isAfter(from)).toList();
    }
    if (to != null) {
      list = list.where((t) => t.timestamp.isBefore(to)).toList();
    }
    return list;
  }

  @override
  Stream<List<domain.Transaction>> watchTransactions({DateTime? from, DateTime? to}) async* {
    await _local.init();
    await for (final models in _local.watchTransactions()) {
      var list = models.map((m) => m.toDomain()).toList();
      if (from != null) list = list.where((t) => t.timestamp.isAfter(from)).toList();
      if (to != null) list = list.where((t) => t.timestamp.isBefore(to)).toList();
      yield list;
    }
  }

  @override
  Future<void> updateTransaction(domain.Transaction tx) async {
    await _local.init();
    final model = TransactionModel.fromDomain(tx);
    await _local.putTransaction(model);
  }

  @override
  Future<void> markSynced(String id) async {
    await _local.init();
    final models = await _local.getAllTransactions();
    final target = models.firstWhere((m) => m.id == id, orElse: () => throw StateError('Not found'));
    final updated = TransactionModel(
      id: target.id,
      amount: target.amount,
      currency: target.currency,
      timestamp: target.timestamp,
      description: target.description,
      categoryId: target.categoryId,
      metadata: target.metadata,
      pendingSync: false,
    );
    await _local.putTransaction(updated);
  }

  @override
  Future<List<domain.Transaction>> getPendingTransactions() async {
    await _local.init();
    final models = await _local.getAllTransactions();
    final pending = models.where((m) => m.pendingSync).map((m) => m.toDomain()).toList();
    return pending;
  }

  @override
  Future<void> processSyncQueue(Future<bool> Function(domain.Transaction tx) uploader, {int maxRetries = 3, Duration? initialDelay}) async {
    await _local.init();
    final pending = await getPendingTransactions();
    final baseDelay = initialDelay ?? Duration(milliseconds: 200);
    for (final tx in pending) {
      var attempt = 0;
      var success = false;
      while (attempt <= maxRetries && !success) {
        try {
          final ok = await uploader(tx);
          if (ok) {
            await markSynced(tx.id);
            success = true;
            break;
          }
        } catch (_) {
          // swallow for retry
        }

        if (!success) {
          if (attempt >= maxRetries) break;
          final backoffMs = (baseDelay.inMilliseconds * (1 << attempt));
          await Future.delayed(Duration(milliseconds: backoffMs));
          attempt++;
        }
      }
    }
  }
}
