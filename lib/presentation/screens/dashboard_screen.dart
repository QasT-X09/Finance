import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finance/core/di/providers.dart';
import 'package:finance/presentation/widgets/balance_card.dart';
import 'package:finance/presentation/widgets/savings_goal_card.dart';
import 'package:finance/presentation/widgets/transaction_item.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txState = ref.watch(transactionsNotifierProvider);

    double total = 0.0;
    txState.whenData((list) {
      total = list.fold(0.0, (p, e) => p + e.amount);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, Alex!', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(onPressed: () => Navigator.pushNamed(context, '/settings'), icon: const Icon(Icons.person))
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => await ref.read(transactionsNotifierProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              BalanceCard(title: 'Total Balance', amount: total, currencySymbol: '₸', onTap: () => Navigator.pushNamed(context, '/wallet')),
              const SizedBox(height: 16),
              // Recent recipients (placeholder)
              SizedBox(
                height: 72,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => CircleAvatar(radius: 28, backgroundColor: Colors.white12, child: Text('A')),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: 6,
                ),
              ),
              const SizedBox(height: 16),
              // Savings goals
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) => SavingsGoalCard(title: ['Car', 'Vacation', 'House'][i % 3], current: (i + 1) * 300, target: (i + 1) * 2000),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: 3,
                ),
              ),
              const SizedBox(height: 16),
              // Transactions preview
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Recent Transactions', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                  TextButton(onPressed: () => Navigator.pushNamed(context, '/transactions'), child: const Text('See all'))
                ]),
              ),
              txState.when(
                data: (list) => Column(children: list.take(4).map((t) => TransactionItem(title: t.description, subtitle: t.currency, date: t.timestamp, amount: t.amount, isExpense: t.amount < 0)).toList()),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error: $e')),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Exchange'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Split'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        onTap: (i) {
          switch (i) {
            case 1:
              Navigator.pushNamed(context, '/wallet');
              break;
            case 2:
              Navigator.pushNamed(context, '/exchange');
              break;
            case 3:
              Navigator.pushNamed(context, '/split');
              break;
            case 4:
              Navigator.pushNamed(context, '/settings');
              break;
            default:
          }
        },
      ),
    );
  }
}
