class Transaction {
  final String id;
  final double amount;
  final String currency;
  final DateTime timestamp;
  final String description;
  final String? categoryId;
  final Map<String, dynamic>? metadata;
  final bool pendingSync;

  Transaction({
    required this.id,
    required this.amount,
    required this.currency,
    required this.timestamp,
    required this.description,
    this.categoryId,
    this.metadata,
    this.pendingSync = false,
  });
}
