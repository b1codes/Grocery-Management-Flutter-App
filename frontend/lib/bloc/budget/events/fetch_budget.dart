import '../budget_event.dart';

class FetchBudget extends BudgetEvent {
  final int month;
  final int year;

  FetchBudget({required this.month, required this.year});
}
