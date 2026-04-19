import 'package:dio/dio.dart';
import 'package:grocery_management_frontend/networking/extensions/dio_extension.dart';

class TripApi {
  final ApiClient _apiClient;

  TripApi({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<Response> startTrip(int storeId) async {
    return _apiClient.post('/api/grocery/grocery-trips/', data: {'store': storeId});
  }

  Future<Response> getTrips({Map<String, dynamic>? queryParameters}) async {
    return _apiClient.get(
      '/api/grocery/grocery-trips/',
      queryParameters: queryParameters ?? {},
    );
  }

  Future<Response> getTrip(int id) async {
    return _apiClient.get('/api/grocery/grocery-trips/$id/');
  }

  Future<Response> addItemToTrip(
    int tripId,
    int pantryItemId,
    double price, {
    int quantity = 1,
  }) async {
    return _apiClient.post(
      '/api/grocery/grocery-trips/$tripId/items/',
      data: {
        'pantry_item': pantryItemId,
        'purchase_price': price,
        'quantity_bought': quantity,
      },
    );
  }

  Future<Response> finishTrip(int tripId) async {
    return _apiClient.patch(
      '/api/grocery/grocery-trips/$tripId/',
      data: {'status': 'completed'},
    );
  }
}
