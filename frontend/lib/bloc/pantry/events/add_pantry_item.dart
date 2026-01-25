import '../pantry_event.dart';

class AddPantryItem extends PantryEvent {
  final String name;
  final int quantity;
  final int categoryId;

  AddPantryItem({
    required this.name,
    required this.quantity,
    required this.categoryId,
  });
}
