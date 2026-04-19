import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/portal/portal_bloc.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            'Grocery App',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: BlocBuilder<PortalBloc, PortalState>(
              builder: (context, state) {
                return ListView(
                  children: [
                    _SideBarItem(
                      icon: Icons.dashboard,
                      label: 'Dashboard',
                      isSelected: state.selectedTab == TabItem.dashboard,
                      onTap: () => context.read<PortalBloc>().add(
                        const SelectTab(TabItem.dashboard),
                      ),
                    ),
                    _SideBarItem(
                      icon: Icons.kitchen,
                      label: 'Pantry',
                      isSelected: state.selectedTab == TabItem.pantry,
                      onTap: () => context.read<PortalBloc>().add(
                        const SelectTab(TabItem.pantry),
                      ),
                    ),
                    _SideBarItem(
                      icon: Icons.restaurant_menu,
                      label: 'Meals',
                      isSelected: state.selectedTab == TabItem.meals,
                      onTap: () => context.read<PortalBloc>().add(
                        const SelectTab(TabItem.meals),
                      ),
                    ),
                    _SideBarItem(
                      icon: Icons.store,
                      label: 'Stores',
                      isSelected: state.selectedTab == TabItem.stores,
                      onTap: () => context.read<PortalBloc>().add(
                        const SelectTab(TabItem.stores),
                      ),
                    ),
                    _SideBarItem(
                      icon: Icons.shopping_cart,
                      label: 'Trips',
                      isSelected: state.selectedTab == TabItem.trips,
                      onTap: () => context.read<PortalBloc>().add(
                        const SelectTab(TabItem.trips),
                      ),
                    ),
                    _SideBarItem(
                      icon: Icons.attach_money,
                      label: 'Budget',
                      isSelected: state.selectedTab == TabItem.budget,
                      onTap: () => context.read<PortalBloc>().add(
                        const SelectTab(TabItem.budget),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Divider(),
          BlocBuilder<PortalBloc, PortalState>(
            builder: (context, state) {
              return _SideBarItem(
                icon: Icons.settings,
                label: 'Settings',
                isSelected: state.selectedTab == TabItem.settings,
                onTap: () => context.read<PortalBloc>().add(
                  const SelectTab(TabItem.settings),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SideBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SideBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
