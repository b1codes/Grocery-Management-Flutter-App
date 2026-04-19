import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/services/managers/meal_manager.dart';
import 'package:grocery_management_frontend/models/meal.dart';

import 'meals_event.dart';
import 'meals_state.dart';

export 'meals_event.dart';
export 'meals_state.dart';

class MealsBloc extends Bloc<MealsEvent, MealsState> {
  final MealManager _mealManager;

  MealsBloc({required MealManager mealManager})
    : _mealManager = mealManager,
      super(const MealsState()) {
    on<FetchMeals>(_onFetchMeals);
    on<AddMeal>(_onAddMeal);
    on<DeleteMeal>(_onDeleteMeal);
    on<ToggleMealFavorite>(_onToggleMealFavorite);
  }

  void _onFetchMeals(FetchMeals event, Emitter<MealsState> emit) async {
    emit(state.copyWith(status: MealsStatus.loading));
    try {
      final meals = await _mealManager.getMeals();
      emit(state.copyWith(status: MealsStatus.success, meals: meals));
    } catch (e) {
      emit(state.copyWith(status: MealsStatus.failure));
    }
  }

  void _onAddMeal(AddMeal event, Emitter<MealsState> emit) async {
    try {
      final newMeal = await _mealManager.createMeal(
        name: event.name,
        description: event.description,
        isFavorite: event.isFavorite,
        ingredients: event.ingredients.map((i) => {
          'pantry_item_template': i.pantryItemTemplate.id,
          'quantity': i.quantity,
          'unit': i.unit,
        }).toList(),
      );
      final updatedMeals = List<Meal>.from(state.meals)..add(newMeal);
      emit(state.copyWith(status: MealsStatus.success, meals: updatedMeals));
    } catch (e) {
      emit(state.copyWith(status: MealsStatus.failure));
    }
  }

  void _onDeleteMeal(DeleteMeal event, Emitter<MealsState> emit) async {
    try {
      await _mealManager.deleteMeal(event.id);
      final updatedMeals = state.meals.where((m) => m.id != event.id).toList();
      emit(state.copyWith(meals: updatedMeals));
    } catch (e) {
      emit(state.copyWith(status: MealsStatus.failure));
    }
  }

  void _onToggleMealFavorite(
    ToggleMealFavorite event,
    Emitter<MealsState> emit,
  ) async {
    try {
      final updatedMeal = await _mealManager.toggleFavorite(
        event.id,
        event.isFavorite,
      );
      final newMeals = state.meals.map((m) {
        return m.id == updatedMeal.id ? updatedMeal : m;
      }).toList();
      emit(state.copyWith(meals: newMeals));
    } catch (e) {
      emit(state.copyWith(status: MealsStatus.failure));
    }
  }
}
