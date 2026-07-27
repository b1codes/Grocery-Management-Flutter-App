import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/insights/insights_bloc.dart';
import 'package:grocery_management_frontend/models/insight.dart';
import 'package:grocery_management_frontend/services/managers/insight_manager.dart';
import 'package:grocery_management_frontend/theme/app_theme.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => InsightsBloc(
        insightManager: context.read<InsightManager>(),
      )..add(const FetchInsights()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nutritional Insights'),
        ),
        body: BlocBuilder<InsightsBloc, InsightsState>(
          builder: (context, state) {
            if (state.status == InsightsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == InsightsStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                    const SizedBox(height: 16),
                    Text('Failed to fetch insights', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => context.read<InsightsBloc>().add(const FetchInsights()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (state.insights.isEmpty && state.status == InsightsStatus.success) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.insights_outlined, size: 64, color: theme.colorScheme.secondary),
                      const SizedBox(height: 16),
                      Text('No Insights Available Yet', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        'As you complete grocery shopping trips, nutritional recommendations will appear here.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Based on your recent history, here are healthier alternatives to consider:',
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.insights.length,
                    itemBuilder: (context, index) {
                      final insight = state.insights[index];
                      return _InsightCard(insight: insight);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: FilledButton.icon(
                    onPressed: () => context.read<InsightsBloc>().add(const FetchInsights()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh Insights'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final Insight insight;

  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'INSTEAD OF',
                        style: theme.textTheme.labelMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        insight.original,
                        style: theme.textTheme.titleMedium?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(Icons.arrow_forward, color: AppTheme.cyanSignal),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'RECOMMENDED',
                        style: theme.textTheme.labelMedium?.copyWith(color: AppTheme.cyanSignal),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        insight.swap,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.cyanSignal,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              insight.reason,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
