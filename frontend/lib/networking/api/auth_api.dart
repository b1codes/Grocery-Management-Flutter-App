import 'package:dio/dio.dart';
import 'package:grocery_management_frontend/networking/extensions/dio_extension.dart';

class AuthApi {
  final ApiClient _apiClient;

  AuthApi({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<Response> login(String email, String password) async {
    return _apiClient.post(
      '/api/auth/login/',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> register(
    String username,
    String email,
    String password,
  ) async {
    return _apiClient.post(
      '/api/auth/register/',
      data: {'username': username, 'email': email, 'password': password},
    );
  }

  void setAuthToken(String token) {
    _apiClient.setAuthToken(token);
  }

  void clearAuthToken() {
    _apiClient.clearAuthToken();
  }
}
