import '../pantry_event.dart';

class SetCategoryFilter extends PantryEvent {
  final int? categoryId;

  SetCategoryFilter(this.categoryId);
}
