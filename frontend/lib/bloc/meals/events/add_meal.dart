import 'package:grocery_management_frontend/models/meal.dart';
import '../meals_event.dart';

class AddMeal extends MealsEvent {
  final String name;
  final String? description;
  final bool isFavorite;
  final List<MealIngredient> ingredients;

  const AddMeal({
    required this.name,
    this.description,
    this.isFavorite = false,
    this.ingredients = const [],
  });
}
