import 'package:dio/dio.dart';
import 'package:grocery_management_frontend/networking/extensions/dio_extension.dart';

class MealApi {
  final ApiClient _apiClient;
Future<Response> getMeals() async {
  return _apiClient.get('/api/meals/meals/');
}

Future<Response> getMeal(int id) async {
  return _apiClient.get('/api/meals/meals/$id/');
}

Future<Response> createMeal(Map<String, dynamic> data) async {
  return _apiClient.post('/api/meals/meals/', data: data);
}

Future<Response> updateMeal(int id, Map<String, dynamic> data) async {
  return _apiClient.patch('/api/meals/meals/$id/', data: data);
}

Future<Response> deleteMeal(int id) async {
  return _apiClient.delete('/api/meals/meals/$id/');
}

Future<Response> toggleFavorite(int id, bool isFavorite) async {
  return _apiClient.patch(
    '/api/meals/meals/$id/',
    data: {'is_favorite': isFavorite},
  );
}
}
