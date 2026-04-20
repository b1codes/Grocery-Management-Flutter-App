import 'package:dio/dio.dart';
import 'package:grocery_management_frontend/networking/extensions/dio_extension.dart';

class BudgetApi {
  final ApiClient _apiClient;

  BudgetApi({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<Response> getMonthlyBudget(int year, int month) async {
    return _apiClient.get(
      '/api/budget/budgets/',
      queryParameters: {'year': year, 'month': month},
    );
  }

  Future<Response> setBudget(int year, int month, double amount) async {
    return _apiClient.post(
      '/api/budget/budgets/',
      data: {'year': year, 'month': month, 'budget_amount': amount},
    );
  }

  Future<Response> getBudgetStats(int year, int month) async {
    return _apiClient.get(
      '/api/budget/budgets/stats/',
      queryParameters: {'year': year, 'month': month},
    );
  }
}
