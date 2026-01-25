import 'package:grocery_management_frontend/models/monthly_budget.dart';

enum BudgetStatus { initial, loading, success, failure }

class BudgetState {
  final MonthlyBudget? budget;
  final BudgetStatus status;

  const BudgetState({this.budget, this.status = BudgetStatus.initial});

  BudgetState copyWith({MonthlyBudget? budget, BudgetStatus? status}) {
    return BudgetState(
      budget: budget ?? this.budget,
      status: status ?? this.status,
    );
  }
}
