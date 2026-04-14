import 'package:finance/presentation/screens/dashboard_screen.dart';
import 'package:finance/presentation/screens/exchange_screen.dart';
import 'package:finance/presentation/screens/profile_screen.dart';
import 'package:finance/presentation/screens/split_bill_screen.dart';
import 'package:finance/presentation/screens/wallet_screen.dart';
import 'package:flutter/material.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int currentIndex = 0;

  final pages = const [
    DashboardScreen(),
    WalletScreen(),
    ExchangeScreen(),
    SplitBillScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: KeyedSubtree(
            key: ValueKey(currentIndex),
            child: pages[currentIndex],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF12182E),
        indicatorColor: const Color(0xFF4A6CF7).withOpacity(0.3),
        selectedIndex: currentIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          NavigationDestination(icon: Icon(Icons.swap_horiz), selectedIcon: Icon(Icons.currency_exchange), label: 'Exchange'),
          NavigationDestination(icon: Icon(Icons.group_outlined), selectedIcon: Icon(Icons.group), label: 'Split'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
        onDestinationSelected: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}
