import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/budget/budget_bloc.dart';
import 'package:grocery_management_frontend/models/monthly_budget.dart';
import 'package:grocery_management_frontend/services/managers/budget_manager.dart';
import 'package:grocery_management_frontend/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class BudgetOverviewScreen extends StatelessWidget {
  const BudgetOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Analytics'),
      ),
      body: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, state) {
          if (state.status == BudgetStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == BudgetStatus.failure) {
            return const Center(child: Text('Failed to fetch budget'));
          }
          if (state.stats == null) {
            return const Center(child: Text('No data available for this month.'));
          }

          final stats = state.stats!;
          final budgetAmount = stats.budgetAmount;
          final totalSpent = stats.totalSpent;
          final percentSpent = budgetAmount > 0 ? (totalSpent / budgetAmount).clamp(0.0, 1.0) : 0.0;
          final isOverBudget = totalSpent > budgetAmount && budgetAmount > 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(context, budgetAmount, totalSpent, percentSpent, isOverBudget),
                const SizedBox(height: 24),
                Text(
                  'Spending Trend',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildSpendingChart(context, stats),
                const SizedBox(height: 24),
                Text(
                  'Recent Trips',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stats.spendingTrends.length,
                  itemBuilder: (context, index) {
                    final trend = stats.spendingTrends.reversed.elementAt(index);
                    return ListTile(
                      leading: const Icon(Icons.shopping_cart_outlined, color: AppTheme.cyanSignal),
                      title: Text(DateFormat('MMM dd, yyyy').format(trend.date)),
                      trailing: Text(
                        '\$${trend.amount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontFamily: 'JetBrains Mono',
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final state = context.read<BudgetBloc>().state;
          _showSetBudgetDialog(context, state.budget);
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    double budget,
    double spent,
    double percent,
    bool isOverBudget,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL SPENT',
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${spent.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                            fontFamily: 'JetBrains Mono',
                            fontWeight: FontWeight.bold,
                            color: isOverBudget ? AppTheme.thermalCore : AppTheme.textPrimary,
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'MONTHLY BUDGET',
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${budget.toStringAsFixed(2)}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontFamily: 'JetBrains Mono',
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: percent,
              minHeight: 10,
              borderRadius: BorderRadius.circular(6),
              backgroundColor: AppTheme.surfaceElevated,
              color: isOverBudget ? AppTheme.thermalCore : AppTheme.cyanSignal,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(percent * 100).toStringAsFixed(1)}% of budget used',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'JetBrains Mono',
                  color: isOverBudget ? AppTheme.thermalCore : AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingChart(BuildContext context, BudgetStats stats) {
    if (stats.spendingTrends.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No spending data yet.')),
      );
    }

    final List<FlSpot> spots = [];
    double cumulativeSpent = 0;

    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(stats.year, stats.month);
    final lastDayToShow = (stats.year == now.year && stats.month == now.month)
        ? now.day
        : daysInMonth;

    for (int day = 1; day <= lastDayToShow; day++) {
      final date = DateTime(stats.year, stats.month, day);
      final trend = stats.spendingTrends.where((t) =>
          t.date.year == date.year &&
          t.date.month == date.month &&
          t.date.day == date.day);

      if (trend.isNotEmpty) {
        cumulativeSpent += trend.fold(0.0, (sum, t) => sum + t.amount);
      }
      spots.add(FlSpot(day.toDouble(), cumulativeSpent));
    }

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 1 || value == 15 || value == lastDayToShow.toDouble()) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 11, color: AppTheme.textSecondary),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppTheme.cyanSignal,
              barWidth: 3.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.cyanSignal.withValues(alpha: 0.15),
              ),
            ),
            if (stats.budgetAmount > 0)
              LineChartBarData(
                spots: [
                  FlSpot(1, stats.budgetAmount),
                  FlSpot(lastDayToShow.toDouble(), stats.budgetAmount),
                ],
                isCurved: false,
                color: AppTheme.thermalCore.withValues(alpha: 0.7),
                barWidth: 2,
                dashArray: [6, 4],
                dotData: const FlDotData(show: false),
              ),
          ],
        ),
      ),
    );
  }

  void _showSetBudgetDialog(BuildContext context, MonthlyBudget? currentBudget) {
    final amountController = TextEditingController(
      text: currentBudget?.budgetAmount.toString() ?? '',
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Set Monthly Budget'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final amount = double.parse(amountController.text);
                  final now = DateTime.now();
                  context.read<BudgetBloc>().add(
                        SetBudget(
                          month: now.month,
                          year: now.year,
                          amount: amount,
                        ),
                      );
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
