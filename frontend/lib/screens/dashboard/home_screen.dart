import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/auth/auth_bloc.dart';
import 'package:grocery_management_frontend/bloc/portal/portal_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 600;
          final crossAxisCount = isWide ? 3 : 1;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Icon(Icons.local_grocery_store, color: theme.colorScheme.primary, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Grocery Command Center',
                                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Manage pantry items, plan grocery runs, and track household expenses.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Quick Navigation', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: isWide ? 2.5 : 3.0,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _QuickActionCard(
                      title: 'Pantry Inventory',
                      subtitle: 'Track food stock & low items',
                      icon: Icons.kitchen,
                      color: Colors.amber,
                      onTap: () => context.read<PortalBloc>().add(const SelectTab(TabItem.pantry)),
                    ),
                    _QuickActionCard(
                      title: 'Meal Planning',
                      subtitle: 'Recipes & ingredient lists',
                      icon: Icons.restaurant_menu,
                      color: Colors.lightGreen,
                      onTap: () => context.read<PortalBloc>().add(const SelectTab(TabItem.meals)),
                    ),
                    _QuickActionCard(
                      title: 'Active Trips',
                      subtitle: 'In-store shopping checklists',
                      icon: Icons.shopping_cart,
                      color: Colors.lightBlue,
                      onTap: () => context.read<PortalBloc>().add(const SelectTab(TabItem.trips)),
                    ),
                    _QuickActionCard(
                      title: 'Stores Directory',
                      subtitle: 'Saved locations & history',
                      icon: Icons.storefront,
                      color: Colors.purple,
                      onTap: () => context.read<PortalBloc>().add(const SelectTab(TabItem.stores)),
                    ),
                    _QuickActionCard(
                      title: 'Budget Analytics',
                      subtitle: 'Spending trends & targets',
                      icon: Icons.account_balance_wallet,
                      color: Colors.teal,
                      onTap: () => context.read<PortalBloc>().add(const SelectTab(TabItem.budget)),
                    ),
                    _QuickActionCard(
                      title: 'Insights',
                      subtitle: 'Household food usage trends',
                      icon: Icons.insights,
                      color: Colors.deepOrange,
                      onTap: () => context.read<PortalBloc>().add(const SelectTab(TabItem.insights)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
