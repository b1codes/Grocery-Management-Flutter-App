import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/budget/budget_bloc.dart';
import 'package:grocery_management_frontend/screens/budget/budget_overview_screen.dart';
import 'package:grocery_management_frontend/services/managers/budget_manager.dart';

class BudgetBlocWidget extends StatelessWidget {
  const BudgetBlocWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BudgetBloc(budgetManager: context.read<BudgetManager>()),
      child: const BudgetOverviewScreen(),
    );
  }
}
