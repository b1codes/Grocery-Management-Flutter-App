import '../budget_event.dart';

class SetBudget extends BudgetEvent {
  final int month;
  final int year;
  final double amount;

  SetBudget({required this.month, required this.year, required this.amount});
}
