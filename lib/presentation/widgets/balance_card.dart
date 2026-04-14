import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class BalanceCard extends StatelessWidget {
  final String title;
  final double amount;
  final String currencySymbol;
  final VoidCallback? onTap;

  const BalanceCard({super.key, required this.title, required this.amount, this.currencySymbol = r'$', this.onTap});

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(colors: [Color(0xFF4A6CF7), Color(0xFF60A5FA)], begin: Alignment.topLeft, end: Alignment.bottomRight);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)]),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(currencySymbol, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(width: 6),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Text(amount.toStringAsFixed(2), key: ValueKey(amount), style: GoogleFonts.poppins(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600)),
                ),
                const Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                )
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: LineChart(LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(spots: const [FlSpot(0, 1), FlSpot(1, 1.2), FlSpot(2, 1.1), FlSpot(3, 1.4)], isCurved: true, color: Colors.white70, barWidth: 2, dotData: FlDotData(show: false)),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
