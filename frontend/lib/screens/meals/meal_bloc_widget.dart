import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/bloc/meals/meals_bloc.dart';
import 'package:grocery_management_frontend/services/managers/meal_manager.dart';
import 'package:grocery_management_frontend/services/managers/trip_manager.dart';
import 'meal_list_screen.dart';

class MealBlocWidget extends StatelessWidget {
  const MealBlocWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MealsBloc(
        mealManager: context.read<MealManager>(),
        tripManager: context.read<TripManager>(),
      )..add(const FetchMeals()),
      child: const MealListScreen(),
    );
  }
}
