import 'package:dio/dio.dart';
import 'package:grocery_management_frontend/networking/extensions/dio_extension.dart';

class MealApi {
  final ApiClient _apiClient;

  MealApi({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<Response> getMeals() async {
    return _apiClient.get('/api/meals/');
  }

  Future<Response> getMeal(int id) async {
    return _apiClient.get('/api/meals/$id/');
  }

  Future<Response> createMeal(Map<String, dynamic> data) async {
    return _apiClient.post('/api/meals/', data: data);
  }

  Future<Response> updateMeal(int id, Map<String, dynamic> data) async {
    return _apiClient.patch('/api/meals/$id/', data: data);
  }

  Future<Response> deleteMeal(int id) async {
    return _apiClient.delete('/api/meals/$id/');
  }

  Future<Response> toggleFavorite(int id, bool isFavorite) async {
    return _apiClient.patch('/api/meals/$id/', data: {'is_favorite': isFavorite});
  }
}
