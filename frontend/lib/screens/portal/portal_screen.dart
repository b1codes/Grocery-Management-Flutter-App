import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/meals/meals_bloc.dart';
import 'package:grocery_management_frontend/bloc/portal/portal_bloc.dart';
import 'package:grocery_management_frontend/bloc/trips/trip_bloc.dart';
import 'package:grocery_management_frontend/components/side_bar.dart';
import 'package:grocery_management_frontend/screens/budget/budget_bloc_widget.dart';
import 'package:grocery_management_frontend/screens/dashboard/home_screen.dart';
import 'package:grocery_management_frontend/screens/dashboard/insights_screen.dart';
import 'package:grocery_management_frontend/screens/meals/meal_bloc_widget.dart';
import 'package:grocery_management_frontend/screens/pantry/pantry_bloc_widget.dart';
import 'package:grocery_management_frontend/screens/stores/store_bloc_widget.dart';
import 'package:grocery_management_frontend/screens/trips/trip_bloc_widget.dart';
import 'package:grocery_management_frontend/services/managers/meal_manager.dart';
import 'package:grocery_management_frontend/services/managers/trip_manager.dart';

class PortalScreen extends StatelessWidget {
  const PortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PortalBloc()),
        BlocProvider(
          create: (context) => MealsBloc(
            mealManager: context.read<MealManager>(),
            tripManager: context.read<TripManager>(),
          )..add(const FetchMeals()),
        ),
        BlocProvider(
          create: (context) => TripBloc(
            tripManager: context.read<TripManager>(),
          ),
        ),
      ],
      child: BlocBuilder<PortalBloc, PortalState>(
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final bool isCompact = constraints.maxWidth < 600;

              if (isCompact) {
                return Scaffold(
                  drawer: const SideBar(isDrawer: true),
                  body: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _buildContent(state.selectedTab),
                  ),
                  bottomNavigationBar: NavigationBar(
                    selectedIndex: _mapTabToBottomNavIndex(state.selectedTab),
                    onDestinationSelected: (index) {
                      final targetTab = _mapBottomNavIndexToTab(index, context);
                      context.read<PortalBloc>().add(SelectTab(targetTab));
                    },
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.dashboard_outlined),
                        selectedIcon: Icon(Icons.dashboard),
                        label: 'Home',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.kitchen_outlined),
                        selectedIcon: Icon(Icons.kitchen),
                        label: 'Pantry',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.restaurant_menu_outlined),
                        selectedIcon: Icon(Icons.restaurant_menu),
                        label: 'Meals',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.shopping_cart_outlined),
                        selectedIcon: Icon(Icons.shopping_cart),
                        label: 'Trips',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.menu_outlined),
                        selectedIcon: Icon(Icons.menu),
                        label: 'More',
                      ),
                    ],
                  ),
                );
              }

              return Scaffold(
                body: Row(
                  children: [
                    const SideBar(isDrawer: false),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _buildContent(state.selectedTab),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  int _mapTabToBottomNavIndex(TabItem tab) {
    switch (tab) {
      case TabItem.dashboard:
        return 0;
      case TabItem.pantry:
        return 1;
      case TabItem.meals:
        return 2;
      case TabItem.trips:
        return 3;
      case TabItem.stores:
      case TabItem.budget:
      case TabItem.insights:
      case TabItem.settings:
        return 4;
    }
  }

  TabItem _mapBottomNavIndexToTab(int index, BuildContext context) {
    switch (index) {
      case 0:
        return TabItem.dashboard;
      case 1:
        return TabItem.pantry;
      case 2:
        return TabItem.meals;
      case 3:
        return TabItem.trips;
      case 4:
        Scaffold.of(context).openDrawer();
        return context.read<PortalBloc>().state.selectedTab;
      default:
        return TabItem.dashboard;
    }
  }

  Widget _buildContent(TabItem tab) {
    switch (tab) {
      case TabItem.dashboard:
        return const HomeScreen();
      case TabItem.pantry:
        return const PantryBlocWidget();
      case TabItem.meals:
        return const MealBlocWidget();
      case TabItem.stores:
        return const StoreBlocWidget();
      case TabItem.trips:
        return const TripBlocWidget();
      case TabItem.budget:
        return const BudgetBlocWidget();
      case TabItem.insights:
        return const InsightsScreen();
      case TabItem.settings:
        return const Center(child: Text("Settings Module"));
    }
  }
}
