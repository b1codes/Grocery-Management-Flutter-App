import 'package:grocery_management_frontend/models/monthly_budget.dart';
import 'package:grocery_management_frontend/services/managers/budget_manager.dart';

enum BudgetStatus { initial, loading, success, failure }

class BudgetState {
  final MonthlyBudget? budget;
  final BudgetStats? stats;
  final BudgetStatus status;

  const BudgetState({
    this.budget,
    this.stats,
    this.status = BudgetStatus.initial,
  });

  BudgetState copyWith({
    MonthlyBudget? budget,
    BudgetStats? stats,
    BudgetStatus? status,
  }) {
    return BudgetState(
      budget: budget ?? this.budget,
      stats: stats ?? this.stats,
      status: status ?? this.status,
    );
  }
}
