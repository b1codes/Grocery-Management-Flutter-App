import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/insights/insights_bloc.dart';
import 'package:grocery_management_frontend/models/insight.dart';
import 'package:grocery_management_frontend/services/managers/insight_manager.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    const Text('Failed to fetch insights.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<InsightsBloc>().add(const FetchInsights()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (state.insights.isEmpty && state.status == InsightsStatus.success) {
              return const Center(child: Text('No insights available yet. Try shopping more!'));
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Based on your recent history, here are some healthier alternatives to consider:',
                    style: Theme.of(context).textTheme.titleMedium,
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
                  child: ElevatedButton.icon(
                    onPressed: () => context.read<InsightsBloc>().add(const FetchInsights()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh Insights'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                        'Instead of:',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
                      ),
                      Text(
                        insight.original,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Colors.green),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Try:',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.green),
                      ),
                      Text(
                        insight.swap,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
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
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
