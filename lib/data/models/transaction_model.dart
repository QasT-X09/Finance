import 'package:finance/domain/entities/transaction.dart' as domain;

class TransactionModel {
  final String id;
  final double amount;
  final String currency;
  final DateTime timestamp;
  final String description;
  final String? categoryId;
  final Map<String, dynamic>? metadata;
  final bool pendingSync;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.timestamp,
    required this.description,
    this.categoryId,
    this.metadata,
    this.pendingSync = false,
  });

  factory TransactionModel.fromDomain(domain.Transaction t, {bool? pendingSyncOverride}) {
    return TransactionModel(
      id: t.id,
      amount: t.amount,
      currency: t.currency,
      timestamp: t.timestamp,
      description: t.description,
      categoryId: t.categoryId,
      metadata: t.metadata,
      pendingSync: pendingSyncOverride ?? t.pendingSync,
    );
  }

  domain.Transaction toDomain() {
    return domain.Transaction(
      id: id,
      amount: amount,
      currency: currency,
      timestamp: timestamp,
      description: description,
      categoryId: categoryId,
      metadata: metadata,
      pendingSync: pendingSync,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'amount': amount,
        'currency': currency,
        'timestamp': timestamp.toIso8601String(),
    'description': description,
    'categoryId': categoryId,
    'metadata': metadata,
    'pendingSync': pendingSync,
      };

  factory TransactionModel.fromMap(Map map) {
    return TransactionModel(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      description: map['description'] as String,
      categoryId: map['categoryId'] as String?,
      metadata: map['metadata'] as Map<String, dynamic>?,
      pendingSync: map['pendingSync'] == null ? false : (map['pendingSync'] as bool),
    );
  }
}
