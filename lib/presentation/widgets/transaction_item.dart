import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime date;
  final double amount;
  final bool isExpense;
  final String? avatarUrl;

  const TransactionItem({super.key, required this.title, required this.subtitle, required this.date, required this.amount, this.isExpense = true, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: Colors.white12, child: Text(title.isNotEmpty ? title[0] : '?')),
      title: Text(title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
      subtitle: Text('$subtitle · ${date.toLocal().toString().split(' ').first}', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
      trailing: Text('${isExpense ? '-' : '+'}\$${amount.toStringAsFixed(2)}', style: GoogleFonts.poppins(color: isExpense ? Colors.redAccent : Colors.greenAccent, fontWeight: FontWeight.w600)),
    );
  }
}
