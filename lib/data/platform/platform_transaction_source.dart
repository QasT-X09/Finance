import 'package:finance/domain/entities/transaction.dart' as domain;

abstract class PlatformTransactionSource {
  /// Parse a raw platform payload into a domain.Transaction if possible.
  /// Return null if payload can't be parsed.
  Future<domain.Transaction?> parse(Map<String, dynamic> raw);
}

class AndroidNotificationParser implements PlatformTransactionSource {
  @override
  Future<domain.Transaction?> parse(Map<String, dynamic> raw) async {
    // Minimal stub: try to map well-known keys
    try {
      final id = raw['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
      final amount = (raw['amount'] is num) ? (raw['amount'] as num).toDouble() : double.tryParse(raw['amount']?.toString() ?? '0');
      final currency = raw['currency']?.toString() ?? 'KZT';
      final ts = raw['timestamp'] != null
          ? DateTime.tryParse(raw['timestamp'].toString())
          : DateTime.now();
      final description = raw['description']?.toString() ?? raw['title']?.toString() ?? 'Android notification';
      if (amount == null) return null;
      return domain.Transaction(id: id, amount: amount, currency: currency, timestamp: ts ?? DateTime.now(), description: description);
    } catch (_) {
      return null;
    }
  }
}

class IOSQuickInputParser implements PlatformTransactionSource {
  @override
  Future<domain.Transaction?> parse(Map<String, dynamic> raw) async {
    // Stub: expect fields similar to Android parser
    try {
      final id = raw['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
      final amount = (raw['amount'] is num) ? (raw['amount'] as num).toDouble() : double.tryParse(raw['amount']?.toString() ?? '0');
      final currency = raw['currency']?.toString() ?? 'KZT';
      final ts = raw['timestamp'] != null
          ? DateTime.tryParse(raw['timestamp'].toString())
          : DateTime.now();
      final description = raw['description']?.toString() ?? 'iOS quick input';
      if (amount == null) return null;
      return domain.Transaction(id: id, amount: amount, currency: currency, timestamp: ts ?? DateTime.now(), description: description);
    } catch (_) {
      return null;
    }
  }
}
