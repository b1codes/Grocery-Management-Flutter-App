import 'package:dio/dio.dart';
import 'package:grocery_management_frontend/networking/extensions/dio_extension.dart';

class StoreApi {
  final ApiClient _apiClient;

  StoreApi({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<Response> getStores() async {
    return _apiClient.get('/api/stores/');
  }

  Future<Response> createStore(String name, String address) async {
    return _apiClient.post(
      '/api/stores/',
      data: {'name': name, 'address': address},
    );
  }
}
