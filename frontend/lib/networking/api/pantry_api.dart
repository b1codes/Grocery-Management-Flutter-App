import 'package:dio/dio.dart';
import 'package:grocery_management_frontend/networking/extensions/dio_extension.dart';

class PantryApi {
  final ApiClient _apiClient;

  PantryApi({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<Response> getPantryItems() async {
    return _apiClient.get('/api/pantry/pantry-items/');
  }

  Future<Response> getCategories() async {
    return _apiClient.get('/api/pantry/categories/');
  }

  Future<Response> createPantryItem(
    String name,
    int quantity,
    int categoryId,
  ) async {
    return _apiClient.post(
      '/api/pantry/pantry-items/',
      data: {'name': name, 'quantity': quantity, 'category': categoryId},
    );
  }

  Future<Response> updatePantryItem(
    int id,
    String name,
    int? categoryId,
  ) async {
    return _apiClient.patch(
      '/api/pantry/pantry-items/$id/',
      data: {'name': name, if (categoryId != null) 'category': categoryId},
    );
  }

  Future<Response> updatePantryItemQuantity(int id, int quantity) async {
    return _apiClient.patch('/api/pantry/pantry-items/$id/', data: {'quantity': quantity});
  }

  Future<Response> deletePantryItem(int id) async {
    return _apiClient.delete('/api/pantry/pantry-items/$id/');
  }
}
