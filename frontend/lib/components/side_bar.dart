import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/portal/portal_bloc.dart';

class SideBar extends StatelessWidget {
  final bool isDrawer;

  const SideBar({super.key, this.isDrawer = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget content = Container(
      width: isDrawer ? null : 250,
      color: colorScheme.surfaceContainerLow,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.local_grocery_store, color: colorScheme.primary, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Grocery Hub',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<PortalBloc, PortalState>(
                builder: (context, state) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    children: [
                      _SideBarItem(
                        icon: Icons.dashboard_outlined,
                        selectedIcon: Icons.dashboard,
                        label: 'Dashboard',
                        isSelected: state.selectedTab == TabItem.dashboard,
                        onTap: () => _onTabSelected(context, TabItem.dashboard),
                      ),
                      _SideBarItem(
                        icon: Icons.kitchen_outlined,
                        selectedIcon: Icons.kitchen,
                        label: 'Pantry',
                        isSelected: state.selectedTab == TabItem.pantry,
                        onTap: () => _onTabSelected(context, TabItem.pantry),
                      ),
                      _SideBarItem(
                        icon: Icons.restaurant_menu_outlined,
                        selectedIcon: Icons.restaurant_menu,
                        label: 'Meals',
                        isSelected: state.selectedTab == TabItem.meals,
                        onTap: () => _onTabSelected(context, TabItem.meals),
                      ),
                      _SideBarItem(
                        icon: Icons.storefront_outlined,
                        selectedIcon: Icons.storefront,
                        label: 'Stores',
                        isSelected: state.selectedTab == TabItem.stores,
                        onTap: () => _onTabSelected(context, TabItem.stores),
                      ),
                      _SideBarItem(
                        icon: Icons.shopping_cart_outlined,
                        selectedIcon: Icons.shopping_cart,
                        label: 'Trips',
                        isSelected: state.selectedTab == TabItem.trips,
                        onTap: () => _onTabSelected(context, TabItem.trips),
                      ),
                      _SideBarItem(
                        icon: Icons.account_balance_wallet_outlined,
                        selectedIcon: Icons.account_balance_wallet,
                        label: 'Budget',
                        isSelected: state.selectedTab == TabItem.budget,
                        onTap: () => _onTabSelected(context, TabItem.budget),
                      ),
                      _SideBarItem(
                        icon: Icons.insights_outlined,
                        selectedIcon: Icons.insights,
                        label: 'Insights',
                        isSelected: state.selectedTab == TabItem.insights,
                        onTap: () => _onTabSelected(context, TabItem.insights),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Divider(height: 1),
            BlocBuilder<PortalBloc, PortalState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: _SideBarItem(
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings,
                    label: 'Settings',
                    isSelected: state.selectedTab == TabItem.settings,
                    onTap: () => _onTabSelected(context, TabItem.settings),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (isDrawer) {
      return Drawer(
        child: content,
      );
    }
    return content;
  }

  void _onTabSelected(BuildContext context, TabItem tab) {
    context.read<PortalBloc>().add(SelectTab(tab));
    if (isDrawer && Scaffold.maybeOf(context)?.isDrawerOpen == true) {
      Navigator.of(context).pop();
    }
  }
}

class _SideBarItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SideBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 14),
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
