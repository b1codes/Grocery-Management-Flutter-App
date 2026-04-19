import '../meals_event.dart';
import 'package:grocery_management_frontend/models/meal.dart';

class CookMeal extends MealsEvent {
  final Meal meal;
  const CookMeal(this.meal);
}

class AddMealToTrip extends MealsEvent {
  final int tripId;
  final Meal meal;
  const AddMealToTrip({required this.tripId, required this.meal});
}
