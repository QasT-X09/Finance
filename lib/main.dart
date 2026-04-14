import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:finance/core/di/providers.dart';
import 'package:finance/presentation/screens/dashboard_screen.dart';
import 'package:finance/presentation/screens/transactions_screen.dart';
import 'package:finance/presentation/screens/add_transaction_screen.dart';
import 'package:finance/presentation/screens/sync_queue_screen.dart';
import 'package:finance/presentation/screens/settings_screen.dart';
import 'package:finance/presentation/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: FinanceApp()));
}

class FinanceApp extends ConsumerStatefulWidget {
  const FinanceApp({super.key});

  @override
  ConsumerState<FinanceApp> createState() => _FinanceAppState();
}

class _FinanceAppState extends ConsumerState<FinanceApp> {
  @override
  void initState() {
    super.initState();
    // Start background sync only in release builds to avoid timers during tests.
    if (kReleaseMode) {
      final bg = ref.read(backgroundSyncProvider);
      bg.start(interval: const Duration(minutes: 15));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Finance Coach',
      theme: AppTheme.darkTheme(),
      initialRoute: '/',
      routes: {
        '/': (_) => const DashboardScreen(),
        '/transactions': (_) => const TransactionsScreen(),
        '/sync_queue': (_) => const SyncQueueScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/add': (_) => const AddTransactionScreen(),
      },
    );
  }
}

