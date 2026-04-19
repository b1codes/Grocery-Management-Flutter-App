import '../meals_event.dart';

class DeleteMeal extends MealsEvent {
  final int id;
  const DeleteMeal(this.id);
}
