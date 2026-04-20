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
    double quantity,
    int categoryId, {
    double minThreshold = 1.0,
    String unit = 'count',
  }) async {
    return _apiClient.post(
      '/api/pantry/pantry-items/',
      data: {
        'name': name,
        'quantity': quantity,
        'category': categoryId,
        'min_threshold': minThreshold,
        'unit': unit,
      },
    );
  }

  Future<Response> updatePantryItem(
    int id, {
    String? name,
    int? categoryId,
    double? minThreshold,
    double? quantity,
    String? unit,
  }) async {
    return _apiClient.patch(
      '/api/pantry/pantry-items/$id/',
      data: {
        if (name != null) 'name': name,
        if (categoryId != null) 'category': categoryId,
        if (minThreshold != null) 'min_threshold': minThreshold,
        if (quantity != null) 'quantity': quantity,
        if (unit != null) 'unit': unit,
      },
    );
  }

  Future<Response> updatePantryItemQuantity(int id, double quantity) async {
    return _apiClient.patch('/api/pantry/pantry-items/$id/', data: {'quantity': quantity});
  }

  Future<Response> deletePantryItem(int id) async {
    return _apiClient.delete('/api/pantry/pantry-items/$id/');
  }
}
