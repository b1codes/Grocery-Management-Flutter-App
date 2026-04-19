import 'dart:developer' as developer;
import 'package:grocery_management_frontend/models/meal.dart';
import 'package:grocery_management_frontend/networking/api/meal_api.dart';

import 'package:grocery_management_frontend/services/managers/pantry_manager.dart';

class MealManager {
  final MealApi _mealApi;
  final PantryManager _pantryManager;

  MealManager({MealApi? mealApi, PantryManager? pantryManager})
      : _mealApi = mealApi ?? MealApi(),
        _pantryManager = pantryManager ?? PantryManager();

  Future<void> cookMeal(Meal meal) async {
    try {
      for (final ingredient in meal.ingredients) {
        final item = ingredient.pantryItemTemplate;
        final newQuantity = (item.quantity - ingredient.quantity).toInt();
        await _pantryManager.updatePantryItemQuantity(
          item.id,
          newQuantity > 0 ? newQuantity : 0,
        );
      }
    } catch (e, stackTrace) {
      developer.log('Error cooking meal', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<Meal>> getMeals() async {
    try {
      final response = await _mealApi.getMeals();
      final List<dynamic> data = response.data;
      return data.map((e) => MealMapper.fromMap(e)).toList();
    } catch (e, stackTrace) {
      developer.log('Error getting meals', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Meal> getMeal(int id) async {
    try {
      final response = await _mealApi.getMeal(id);
      return MealMapper.fromMap(response.data);
    } catch (e, stackTrace) {
      developer.log('Error getting meal with id $id', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Meal> createMeal({
    required String name,
    String? description,
    bool isFavorite = false,
    required List<Map<String, dynamic>> ingredients,
  }) async {
    try {
      final response = await _mealApi.createMeal({
        'name': name,
        'description': description,
        'is_favorite': isFavorite,
        'ingredients': ingredients,
      });
      return MealMapper.fromMap(response.data);
    } catch (e, stackTrace) {
      developer.log('Error creating meal', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Meal> updateMeal(
    int id, {
    String? name,
    String? description,
    bool? isFavorite,
    List<Map<String, dynamic>>? ingredients,
  }) async {
    try {
      final response = await _mealApi.updateMeal(id, {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (isFavorite != null) 'is_favorite': isFavorite,
        if (ingredients != null) 'ingredients': ingredients,
      });
      return MealMapper.fromMap(response.data);
    } catch (e, stackTrace) {
      developer.log('Error updating meal with id $id', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> deleteMeal(int id) async {
    try {
      await _mealApi.deleteMeal(id);
    } catch (e, stackTrace) {
      developer.log('Error deleting meal with id $id', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Meal> toggleFavorite(int id, bool isFavorite) async {
    try {
      final response = await _mealApi.toggleFavorite(id, isFavorite);
      return MealMapper.fromMap(response.data);
    } catch (e, stackTrace) {
      developer.log('Error toggling favorite for meal with id $id', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
