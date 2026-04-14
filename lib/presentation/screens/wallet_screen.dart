import 'package:finance/presentation/widgets/balance_card.dart';
import 'package:finance/presentation/widgets/transaction_item.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  static const _glassCard = Color.fromRGBO(255, 255, 255, 0.05);
  static const _textSecondary = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => Future<void>.delayed(const Duration(milliseconds: 500)),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          const Text('My Wallet', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          const BalanceCard(title: 'Total Balance', amount: 15682.0, percentageChange: '+5.25%'),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: _glassCard, borderRadius: BorderRadius.circular(16)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total receive', style: TextStyle(color: _textSecondary)),
                SizedBox(height: 8),
                LinearProgressIndicator(value: 0.86, minHeight: 8),
                SizedBox(height: 6),
                Align(alignment: Alignment.centerRight, child: Text('86%')),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('Recent categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _CategoryCard(icon: Icons.favorite_border, title: 'Health', amount: '\$120.50'),
              _CategoryCard(icon: Icons.movie_filter_outlined, title: 'Entertainment', amount: '\$150.87'),
              _CategoryCard(icon: Icons.flight_takeoff, title: 'Travel', amount: '\$90.10'),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Transaction history', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          TransactionItem(
            title: 'Amazon',
            subtitle: 'Shopping',
            date: DateTime(2026, 1, 10),
            amount: 123.43,
            logoUrl: 'https://logo.clearbit.com/amazon.com',
            isExpense: true,
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.icon, required this.title, required this.amount});

  final IconData icon;
  final String title;
  final String amount;

  static const _glassCard = Color.fromRGBO(255, 255, 255, 0.05);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 92,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: _glassCard, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const Spacer(),
          Text(title, style: const TextStyle(fontSize: 12)),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
