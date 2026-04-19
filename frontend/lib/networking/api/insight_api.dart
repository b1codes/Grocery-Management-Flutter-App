import 'package:dio/dio.dart';
import 'package:grocery_management_frontend/networking/extensions/dio_extension.dart';

class InsightApi {
  final ApiClient _apiClient;

  InsightApi({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<Response> getInsights() async {
    return _apiClient.get('/api/meals/insights/');
  }
}
