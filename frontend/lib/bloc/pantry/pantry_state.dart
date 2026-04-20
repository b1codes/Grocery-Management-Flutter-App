import 'package:grocery_management_frontend/models/pantry_item.dart';
import 'package:grocery_management_frontend/models/category.dart';

enum PantryStatus { initial, loading, success, failure }

class PantryState {
  final List<PantryItem> items;
  final List<Category> categories;
  final int? selectedCategoryId;
  final PantryStatus status;

  const PantryState({
    this.items = const [],
    this.categories = const [],
    this.selectedCategoryId,
    this.status = PantryStatus.initial,
  });

  List<PantryItem> get filteredItems {
    if (selectedCategoryId == null) {
      return items;
    }
    return items.where((item) => item.category == selectedCategoryId).toList();
  }

  PantryState copyWith({
    List<PantryItem>? items,
    List<Category>? categories,
    int? selectedCategoryId,
    bool clearCategoryFilter = false,
    PantryStatus? status,
  }) {
    return PantryState(
      items: items ?? this.items,
      categories: categories ?? this.categories,
      selectedCategoryId: clearCategoryFilter
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      status: status ?? this.status,
    );
  }
}
