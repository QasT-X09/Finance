import 'package:finance/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({super.key});

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  String from = 'USD';
  String to = 'EUR';
  String amount = '320';

  @override
  Widget build(BuildContext context) {
    final converted = (double.tryParse(amount) ?? 0) * 0.969;
    const rate = '1 USD = 0.969 EUR';
    const fee = 1.20;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        const Text('Currency Exchange', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        _SelectorTile(label: 'From', currency: from, amount: '\$$amount', onTap: () => _pickCurrency(true)),
        const SizedBox(height: 12),
        _SelectorTile(label: 'To', currency: to, amount: '\$${converted.toStringAsFixed(2)}', onTap: () => _pickCurrency(false)),
        const SizedBox(height: 16),
        Text(rate, style: const TextStyle(color: AppTheme.textSecondary)),
        const SizedBox(height: 4),
        const Text('Platform Fee: \$1.20', style: TextStyle(color: AppTheme.textSecondary)),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => HapticFeedback.mediumImpact(),
          icon: const Icon(Icons.swap_horiz),
          label: const Text('Exchange'),
          style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
        ),
        const SizedBox(height: 18),
        _NumericPad(
          onTap: (digit) => setState(() {
            if (digit == '⌫') {
              if (amount.isNotEmpty) {
                amount = amount.substring(0, amount.length - 1);
              }
            } else {
              amount += digit;
            }
          }),
        ),
      ],
    );
  }

  Future<void> _pickCurrency(bool isFrom) async {
    final currencies = ['USD', 'EUR', 'GBP', 'KZT'];
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => ListView(children: currencies.map((e) => ListTile(title: Text(e), onTap: () => Navigator.pop(context, e))).toList()),
    );
    if (selected != null) {
      setState(() {
        if (isFrom) {
          from = selected;
        } else {
          to = selected;
        }
      });
    }
  }
}

class _SelectorTile extends StatelessWidget {
  const _SelectorTile({required this.label, required this.currency, required this.amount, required this.onTap});

  final String label;
  final String currency;
  final String amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppTheme.glassCard, borderRadius: BorderRadius.circular(16)),
        child: Row(children: [Text(label), const Spacer(), Text(currency, style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(width: 12), Text(amount)]),
      ),
    );
  }
}

class _NumericPad extends StatelessWidget {
  const _NumericPad({required this.onTap});
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '⌫'];
    return GridView.builder(
      itemCount: keys.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1.7),
      itemBuilder: (_, i) {
        return InkWell(
          onTap: () => onTap(keys[i]),
          child: Ink(
            decoration: BoxDecoration(color: AppTheme.glassCard, borderRadius: BorderRadius.circular(14)),
            child: Center(child: Text(keys[i], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600))),
          ),
        );
      },
    );
  }
}
