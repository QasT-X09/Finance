import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.logoUrl,
    required this.isExpense,
  });

  final String title;
  final String subtitle;
  final DateTime date;
  final double amount;
  final String logoUrl;
  final bool isExpense;

  static const _glassCard = Color.fromRGBO(255, 255, 255, 0.05);
  static const _textSecondary = Color(0xFF94A3B8);
  static const _success = Color(0xFF10B981);
  static const _danger = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _glassCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: logoUrl,
              width: 34,
              height: 34,
              fit: BoxFit.cover,
              placeholder: (_, __) => const CircularProgressIndicator(strokeWidth: 2),
              errorWidget: (_, __, ___) => const Icon(Icons.store, color: Colors.black87),
            ),
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '$subtitle · ${date.day}/${date.month}/${date.year}',
          style: const TextStyle(color: _textSecondary, fontSize: 12),
        ),
        trailing: Text(
          '${isExpense ? '-' : '+'}\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: isExpense ? _danger : _success,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
