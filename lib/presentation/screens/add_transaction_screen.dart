import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finance/core/di/providers.dart';
import 'package:finance/domain/entities/transaction.dart' as domain;

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  @override
  void dispose() {
    _descCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(controller: _amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount')),
              const SizedBox(height: 8),
              TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final amt = double.tryParse(_amountCtrl.text) ?? 0.0;
                  final desc = _descCtrl.text.trim();
                  final tx = domain.Transaction(id: DateTime.now().millisecondsSinceEpoch.toString(), amount: amt, currency: 'KZT', timestamp: DateTime.now(), description: desc);
                  final navigator = Navigator.of(context);
                  await ref.read(transactionsNotifierProvider.notifier).add(tx);
                  if (!mounted) return;
                  navigator.pop();
                },
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
