import '../meals_event.dart';

class ToggleMealFavorite extends MealsEvent {
  final int id;
  final bool isFavorite;

  const ToggleMealFavorite({required this.id, required this.isFavorite});
}
