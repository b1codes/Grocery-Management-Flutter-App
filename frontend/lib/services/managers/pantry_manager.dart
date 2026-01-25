import 'package:grocery_management_frontend/models/pantry_item.dart';
import 'package:grocery_management_frontend/networking/api/pantry_api.dart';
import 'package:grocery_management_frontend/networking/dto/pantry_item_dto.dart';

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

  Future<PantryItem> createPantryItem(
    String name,
    int quantity,
    int categoryId,
  ) async {
    final response = await _pantryApi.createPantryItem(
      name,
      quantity,
      categoryId,
    );
    final pantryItemDto = PantryItemDto.fromMap(response.data);
    return pantryItemDto.toPantryItem();
  }

  Future<PantryItem> updatePantryItem(
    int id,
    String name,
    int? categoryId,
  ) async {
    final response = await _pantryApi.updatePantryItem(id, name, categoryId);
    final pantryItemDto = PantryItemDto.fromMap(response.data);
    return pantryItemDto.toPantryItem();
  }

  Future<PantryItem> updatePantryItemQuantity(int id, int quantity) async {
    final response = await _pantryApi.updatePantryItemQuantity(id, quantity);
    final pantryItemDto = PantryItemDto.fromMap(response.data);
    return pantryItemDto.toPantryItem();
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
      category: category,
      lastUpdated: lastUpdated,
      regularPrice: regularPrice,
    );
  }
}
