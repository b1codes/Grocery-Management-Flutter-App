import 'package:dart_mappable/dart_mappable.dart';
import 'package:grocery_management_frontend/models/pantry_item.dart';

part 'meal.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Meal with MealMappable {
  const Meal({
    required this.id,
    required this.name,
    this.description,
    required this.user,
    this.isFavorite = false,
    required this.ingredients,
  });

  final int id;
  final String name;
  final String? description;
  final int user;
  final bool isFavorite;
  final List<MealIngredient> ingredients;
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class MealIngredient with MealIngredientMappable {
  const MealIngredient({
    required this.id,
    required this.pantryItemTemplate,
    required this.quantity,
    this.unit,
  });

  final int id;
  final PantryItem pantryItemTemplate;
  final double quantity;
  final String? unit;
}
