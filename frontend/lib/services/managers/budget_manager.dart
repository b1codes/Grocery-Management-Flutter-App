import 'package:grocery_management_frontend/models/monthly_budget.dart';
import 'package:grocery_management_frontend/networking/api/budget_api.dart';
import 'package:grocery_management_frontend/networking/dto/monthly_budget_dto.dart';

class BudgetManager {
  final BudgetApi _budgetApi;

  BudgetManager({BudgetApi? budgetApi}) : _budgetApi = budgetApi ?? BudgetApi();

  Future<MonthlyBudget> getMonthlyBudget(int year, int month) async {
    final response = await _budgetApi.getMonthlyBudget(year, month);
    final budgetDto = MonthlyBudgetDto.fromMap(response.data);
    return budgetDto.toMonthlyBudget();
  }

  Future<MonthlyBudget> setBudget(int year, int month, double amount) async {
    final response = await _budgetApi.setBudget(year, month, amount);
    final budgetDto = MonthlyBudgetDto.fromMap(response.data);
    return budgetDto.toMonthlyBudget();
  }
}

extension on MonthlyBudgetDto {
  MonthlyBudget toMonthlyBudget() {
    return MonthlyBudget(
      id: id,
      month: month,
      year: year,
      budgetAmount: budgetAmount,
    );
  }
}
