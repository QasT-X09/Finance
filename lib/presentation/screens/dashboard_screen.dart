import 'package:finance/presentation/bloc/dashboard_cubit.dart';
import 'package:finance/presentation/widgets/balance_card.dart';
import 'package:finance/presentation/widgets/savings_goal_card.dart';
import 'package:finance/presentation/widgets/transaction_item.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const _glassCard = Color.fromRGBO(255, 255, 255, 0.05);
  static const _primaryAccent = Color(0xFF4A6CF7);
  static const _secondaryAccent = Color(0xFF60A5FA);

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    const recipients = [
      'https://i.pravatar.cc/100?img=1',
      'https://i.pravatar.cc/100?img=2',
      'https://i.pravatar.cc/100?img=3',
      'https://i.pravatar.cc/100?img=4',
      'https://i.pravatar.cc/100?img=5',
    ];

    return BlocProvider(
      create: (_) => DashboardCubit(),
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 23,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=9'),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Hello, Alex!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.toNamed('/transactions'),
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const BalanceCard(title: 'Total Balance', amount: 24000.98),
            const SizedBox(height: 20),
            const Text('Recent recipients', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recipients.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, index) {
                  if (index == 0) {
                    return Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(27),
                      ),
                      child: const Icon(Icons.add, color: Colors.black),
                    );
                  }
                  return CircleAvatar(radius: 27, backgroundImage: NetworkImage(recipients[index - 1]));
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text('Savings goals', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  SavingsGoalCard(title: 'Car', current: 3074, target: 12000),
                  SizedBox(width: 10),
                  SavingsGoalCard(title: 'Vacation', current: 1500, target: 4000),
                  SizedBox(width: 10),
                  SavingsGoalCard(title: 'House', current: 12023, target: 50000),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _IncomeExpenseCard(),
            const SizedBox(height: 18),
            const Text('Recent Transactions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Shimmer.fromColors(
              baseColor: _glassCard,
              highlightColor: Colors.white10,
              child: TransactionItem(
                title: 'Apple',
                subtitle: 'Subscription',
                date: DateTime(2026, 1, 12),
                amount: 24,
                logoUrl: 'https://logo.clearbit.com/apple.com',
                isExpense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncomeExpenseCard extends StatelessWidget {
  const _IncomeExpenseCard();

  static const _glassCard = Color.fromRGBO(255, 255, 255, 0.05);
  static const _primaryAccent = Color(0xFF4A6CF7);
  static const _secondaryAccent = Color(0xFF60A5FA);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _glassCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: BlocBuilder<DashboardCubit, ChartMode>(
        builder: (context, mode) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _chip(context, ChartMode.spend, 'Spend', mode),
                  const SizedBox(width: 8),
                  _chip(context, ChartMode.income, 'Income', mode),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: BarChart(
                  BarChartData(
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(show: false),
                    barGroups: List.generate(7, (i) {
                      final values = mode == ChartMode.income
                          ? [8.0, 12.0, 10.0, 13.0, 11.0, 16.0, 14.0]
                          : [7.0, 8.0, 6.0, 9.0, 5.0, 10.0, 8.0];
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: values[i],
                            color: _secondaryAccent,
                            width: 10,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _chip(BuildContext context, ChartMode value, String label, ChartMode mode) {
    final selected = value == mode;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        context.read<DashboardCubit>().toggle(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _primaryAccent : Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label),
      ),
    );
  }
}
