export 'events/fetch_meals.dart';
export 'events/add_meal.dart';
export 'events/delete_meal.dart';
export 'events/toggle_meal_favorite.dart';

abstract class MealsEvent {
  const MealsEvent();
}
