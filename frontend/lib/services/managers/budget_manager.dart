import 'package:grocery_management_frontend/models/monthly_budget.dart';
import 'package:grocery_management_frontend/networking/api/budget_api.dart';
import 'package:grocery_management_frontend/networking/dto/monthly_budget_dto.dart';

class BudgetStats {
  final int month;
  final int year;
  final double budgetAmount;
  final double totalSpent;
  final List<SpendingTrend> spendingTrends;

  BudgetStats({
    required this.month,
    required this.year,
    required this.budgetAmount,
    required this.totalSpent,
    required this.spendingTrends,
  });
}

class SpendingTrend {
  final DateTime date;
  final double amount;

  SpendingTrend({required this.date, required this.amount});
}

class BudgetManager {
  final BudgetApi _budgetApi;

  BudgetManager({BudgetApi? budgetApi}) : _budgetApi = budgetApi ?? BudgetApi();

  Future<MonthlyBudget?> getMonthlyBudget(int year, int month) async {
    final response = await _budgetApi.getMonthlyBudget(year, month);
    final List data = response.data as List;
    if (data.isEmpty) return null;

    final budgetDto = MonthlyBudgetDto.fromMap(data.first);
    return budgetDto.toMonthlyBudget();
  }

  Future<MonthlyBudget> setBudget(int year, int month, double amount) async {
    final response = await _budgetApi.setBudget(year, month, amount);
    final budgetDto = MonthlyBudgetDto.fromMap(response.data);
    return budgetDto.toMonthlyBudget();
  }

  Future<BudgetStats> getBudgetStats(int year, int month) async {
    final response = await _budgetApi.getBudgetStats(year, month);
    final data = response.data as Map<String, dynamic>;

    return BudgetStats(
      month: data['month'],
      year: data['year'],
      budgetAmount: (data['budget_amount'] as num).toDouble(),
      totalSpent: (data['total_spent'] as num).toDouble(),
      spendingTrends: (data['spending_trends'] as List).map((e) {
        return SpendingTrend(
          date: DateTime.parse(e['date']),
          amount: (e['amount'] as num).toDouble(),
        );
      }).toList(),
    );
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
