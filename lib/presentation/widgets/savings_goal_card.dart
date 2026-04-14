import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SavingsGoalCard extends StatelessWidget {
  final String title;
  final double current;
  final double target;

  const SavingsGoalCard({super.key, required this.title, required this.current, required this.target});

  @override
  Widget build(BuildContext context) {
    final pct = (target <= 0) ? 0.0 : (current / target).clamp(0.0, 1.0);
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text('\$${current.toStringAsFixed(0)}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: pct, minHeight: 8, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent)),
          ),
          const SizedBox(height: 6),
          Text('${(pct * 100).toStringAsFixed(0)}%', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
