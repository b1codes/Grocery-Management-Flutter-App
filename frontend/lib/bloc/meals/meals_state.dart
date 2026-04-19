import 'package:grocery_management_frontend/models/meal.dart';

enum MealsStatus { initial, loading, success, failure }

class MealsState {
  final List<Meal> meals;
  final MealsStatus status;

  const MealsState({
    this.meals = const [],
    this.status = MealsStatus.initial,
  });

  MealsState copyWith({List<Meal>? meals, MealsStatus? status}) {
    return MealsState(
      meals: meals ?? this.meals,
      status: status ?? this.status,
    );
  }
}
