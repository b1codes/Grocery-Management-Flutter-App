import '../pantry_event.dart';

class UpdatePantryItem extends PantryEvent {
  final int id;
  final String? name;
  final int? quantity;
  final int? minThreshold;
  final int? categoryId;

  UpdatePantryItem({
    required this.id,
    this.name,
    this.quantity,
    this.minThreshold,
    this.categoryId,
  });
}
