import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/portal/portal_bloc.dart';
import 'package:grocery_management_frontend/components/side_bar.dart';
import 'package:grocery_management_frontend/screens/budget/budget_bloc_widget.dart';
import 'package:grocery_management_frontend/screens/dashboard/home_screen.dart';
import 'package:grocery_management_frontend/screens/pantry/pantry_bloc_widget.dart';
import 'package:grocery_management_frontend/screens/stores/store_bloc_widget.dart';
import 'package:grocery_management_frontend/screens/trips/trip_bloc_widget.dart';

class PortalScreen extends StatelessWidget {
  const PortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PortalBloc(),
      child: Scaffold(
        body: Row(
          children: [
            const SideBar(),
            Expanded(
              child: BlocBuilder<PortalBloc, PortalState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildContent(state.selectedTab),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(TabItem tab) {
    switch (tab) {
      case TabItem.dashboard:
        return const HomeScreen();
      case TabItem.pantry:
        return const PantryBlocWidget();
      case TabItem.stores:
        return const StoreBlocWidget();
      case TabItem.trips:
        return const TripBlocWidget();
      case TabItem.budget:
        return const BudgetBlocWidget();
      case TabItem.settings:
        return const Center(child: Text("Settings Module Coming Soon"));
    }
  }
}
