import 'package:finance/presentation/navigation/root_shell.dart';
import 'package:finance/presentation/screens/transactions_screen.dart';
import 'package:finance/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

void main() {
  runApp(const ProviderScope(child: FinanceApp()));
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Finance Coach',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      getPages: [
        GetPage(name: '/', page: () => const RootShell()),
        GetPage(name: '/transactions', page: () => const TransactionsScreen()),
      ],
      initialRoute: '/',
    );
  }
}
