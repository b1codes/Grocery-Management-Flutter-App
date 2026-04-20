import '../pantry_event.dart';

class AddPantryItem extends PantryEvent {
  final String name;
  final double quantity;
  final int categoryId;
  final double minThreshold;
  final String unit;

  AddPantryItem({
    required this.name,
    required this.quantity,
    required this.categoryId,
    this.minThreshold = 1.0,
    this.unit = 'count',
  });
}
