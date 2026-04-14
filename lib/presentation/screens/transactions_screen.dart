import 'package:finance/presentation/widgets/transaction_item.dart';
import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final txs = [
      const TransactionItem(
        title: 'Apple',
        subtitle: 'Subscription',
        date: DateTime(2026, 1, 12),
        amount: 24.00,
        logoUrl: 'https://logo.clearbit.com/apple.com',
        isExpense: true,
      ),
      const TransactionItem(
        title: 'McDonald\'s',
        subtitle: 'Restaurant',
        date: DateTime(2026, 1, 11),
        amount: 9.99,
        logoUrl: 'https://logo.clearbit.com/mcdonalds.com',
        isExpense: true,
      ),
      const TransactionItem(
        title: 'Amazon',
        subtitle: 'Shopping',
        date: DateTime(2026, 1, 9),
        amount: 123.43,
        logoUrl: 'https://logo.clearbit.com/amazon.com',
        isExpense: true,
      ),
      const TransactionItem(
        title: 'Freelance',
        subtitle: 'Income',
        date: DateTime(2026, 1, 8),
        amount: 560.00,
        logoUrl: 'https://logo.clearbit.com/upwork.com',
        isExpense: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Recent Transactions')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Filter by date',
                    prefixIcon: const Icon(Icons.calendar_month),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  readOnly: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...txs,
        ],
      ),
    );
  }
}
