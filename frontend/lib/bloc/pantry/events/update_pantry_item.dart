import '../pantry_event.dart';

class UpdatePantryItem extends PantryEvent {
  final int id;
  final int quantity;

  UpdatePantryItem({required this.id, required this.quantity});
}
