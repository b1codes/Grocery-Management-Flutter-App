import '../pantry_event.dart';

class UpdatePantryItem extends PantryEvent {
  final int id;
  final String? name;
  final double? quantity;
  final double? minThreshold;
  final int? categoryId;
  final String? unit;

  UpdatePantryItem({
    required this.id,
    this.name,
    this.quantity,
    this.minThreshold,
    this.categoryId,
    this.unit,
  });
}
