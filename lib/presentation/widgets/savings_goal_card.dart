import 'dart:ui';

import 'package:flutter/material.dart';

class SavingsGoalCard extends StatelessWidget {
  const SavingsGoalCard({
    super.key,
    required this.title,
    required this.current,
    required this.target,
  });

  final String title;
  final double current;
  final double target;

  static const _glassCard = Color.fromRGBO(255, 255, 255, 0.05);
  static const _textSecondary = Color(0xFF94A3B8);
  static const _secondaryAccent = Color(0xFF60A5FA);

  @override
  Widget build(BuildContext context) {
    final progress = ((target == 0 ? 0.0 : current / target).clamp(0.0, 1.0)).toDouble();

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          width: 170,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: _glassCard,
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 4),
              Text('Target: \$${target.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: _textSecondary)),
              const SizedBox(height: 10),
              Text('\$${current.toStringAsFixed(0)} saved', style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 8),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: progress),
                duration: const Duration(milliseconds: 300),
                builder: (_, value, __) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: value,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(_secondaryAccent),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('${(progress * 100).toStringAsFixed(0)}% completed', style: const TextStyle(fontSize: 12, color: _textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
