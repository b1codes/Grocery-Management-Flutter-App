import 'package:grocery_management_frontend/models/meal.dart';
import 'package:grocery_management_frontend/networking/api/meal_api.dart';

class MealManager {
  final MealApi _mealApi;

  MealManager({MealApi? mealApi}) : _mealApi = mealApi ?? MealApi();

  Future<List<Meal>> getMeals() async {
    final response = await _mealApi.getMeals();
    final List<dynamic> data = response.data;
    return data.map((e) => MealMapper.fromMap(e)).toList();
  }

  Future<Meal> getMeal(int id) async {
    final response = await _mealApi.getMeal(id);
    return MealMapper.fromMap(response.data);
  }

  Future<Meal> createMeal({
    required String name,
    String? description,
    required List<Map<String, dynamic>> ingredients,
  }) async {
    final response = await _mealApi.createMeal({
      'name': name,
      'description': description,
      'ingredients': ingredients,
    });
    return MealMapper.fromMap(response.data);
  }

  Future<Meal> updateMeal(
    int id, {
    String? name,
    String? description,
    bool? isFavorite,
    List<Map<String, dynamic>>? ingredients,
  }) async {
    final response = await _mealApi.updateMeal(id, {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (ingredients != null) 'ingredients': ingredients,
    });
    return MealMapper.fromMap(response.data);
  }

  Future<void> deleteMeal(int id) async {
    await _mealApi.deleteMeal(id);
  }

  Future<Meal> toggleFavorite(int id, bool isFavorite) async {
    final response = await _mealApi.toggleFavorite(id, isFavorite);
    return MealMapper.fromMap(response.data);
  }
}
