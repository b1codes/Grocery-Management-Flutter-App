export 'events/fetch_meals.dart';
export 'events/add_meal.dart';
export 'events/delete_meal.dart';
export 'events/toggle_meal_favorite.dart';
export 'events/meal_actions.dart';

abstract class MealsEvent {
  const MealsEvent();
}
