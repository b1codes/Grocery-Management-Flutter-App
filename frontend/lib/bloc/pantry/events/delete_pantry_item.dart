import '../pantry_event.dart';

class DeletePantryItem extends PantryEvent {
  final int id;

  DeletePantryItem({required this.id});
}
