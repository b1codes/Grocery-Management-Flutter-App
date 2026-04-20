import 'package:grocery_management_frontend/models/pantry_item.dart';
import 'package:grocery_management_frontend/models/category.dart';
import 'package:grocery_management_frontend/networking/api/pantry_api.dart';
import 'package:grocery_management_frontend/networking/dto/pantry_item_dto.dart';
import 'package:grocery_management_frontend/networking/dto/category_dto.dart';

class PantryManager {
  final PantryApi _pantryApi;

  PantryManager({PantryApi? pantryApi}) : _pantryApi = pantryApi ?? PantryApi();

  Future<List<PantryItem>> getPantryItems() async {
    final response = await _pantryApi.getPantryItems();
    final pantryItemDtos = (response.data as List)
        .map((e) => PantryItemDto.fromMap(e))
        .toList();
    return pantryItemDtos.map((dto) => dto.toPantryItem()).toList();
  }

  Future<List<Category>> getCategories() async {
    final response = await _pantryApi.getCategories();
    final categoryDtos = (response.data as List)
        .map((e) => CategoryDto.fromMap(e))
        .toList();
    return categoryDtos.map((dto) => dto.toCategory()).toList();
  }

  Future<PantryItem> createPantryItem(
    String name,
    int quantity,
    int categoryId, {
    int minThreshold = 1,
  }) async {
    final response = await _pantryApi.createPantryItem(
      name,
      quantity,
      categoryId,
      minThreshold: minThreshold,
    );
    final pantryItemDto = PantryItemDto.fromMap(response.data);
    return pantryItemDto.toPantryItem();
  }

  Future<PantryItem> updatePantryItem({
    required int id,
    String? name,
    int? categoryId,
    int? minThreshold,
    int? quantity,
  }) async {
    final response = await _pantryApi.updatePantryItem(
      id,
      name: name,
      categoryId: categoryId,
      minThreshold: minThreshold,
      quantity: quantity,
    );
    final pantryItemDto = PantryItemDto.fromMap(response.data);
    return pantryItemDto.toPantryItem();
  }

  Future<PantryItem> updatePantryItemQuantity(int id, int quantity) async {
    return updatePantryItem(id: id, quantity: quantity);
  }

  Future<void> deletePantryItem(int id) async {
    await _pantryApi.deletePantryItem(id);
  }
}

extension on PantryItemDto {
  PantryItem toPantryItem() {
    return PantryItem(
      id: id,
      name: name,
      quantity: quantity,
      minThreshold: minThreshold,
      category: category,
      lastUpdated: lastUpdated,
      regularPrice: regularPrice,
    );
  }
}
