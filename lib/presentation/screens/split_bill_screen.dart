import 'package:flutter/material.dart';

class SplitBillScreen extends StatelessWidget {
  const SplitBillScreen({super.key});

  static const _primaryAccent = Color(0xFF4A6CF7);
  static const _glassCard = Color.fromRGBO(255, 255, 255, 0.05);
  static const _textSecondary = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        const Text('Split Bill', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        _field('Restaurant/Venue', 'Moonlight Lounge'),
        const SizedBox(height: 10),
        _field('Bill amount', '\$230.00'),
        const SizedBox(height: 10),
        _field('Transfer ID', '#45671892'),
        const SizedBox(height: 16),
        const Text('Recent recipients', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        SizedBox(
          height: 70,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              CircleAvatar(radius: 27, backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=11')),
              SizedBox(width: 10),
              CircleAvatar(radius: 27, backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=12')),
              SizedBox(width: 10),
              CircleAvatar(radius: 27, backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=13')),
              SizedBox(width: 10),
              CircleAvatar(radius: 27, backgroundColor: Colors.white, child: Icon(Icons.add, color: Colors.black)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: _primaryAccent, borderRadius: BorderRadius.circular(20)),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Split between friends', style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text('Alex: \$57.50\nSam: \$57.50\nChris: \$57.50\nYou: \$57.50'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _field(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: _glassCard, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Text(label),
          const Spacer(),
          Text(value, style: const TextStyle(color: _textSecondary)),
        ],
      ),
    );
  }
}
