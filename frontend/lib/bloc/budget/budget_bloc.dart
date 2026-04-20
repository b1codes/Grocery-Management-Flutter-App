import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/services/managers/budget_manager.dart';

import 'budget_event.dart';
import 'budget_state.dart';

export 'budget_event.dart';
export 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final BudgetManager _budgetManager;

  BudgetBloc({required BudgetManager budgetManager})
    : _budgetManager = budgetManager,
      super(const BudgetState()) {
    on<FetchBudget>(_onFetchBudget);
    on<SetBudget>(_onSetBudget);
  }

  void _onFetchBudget(FetchBudget event, Emitter<BudgetState> emit) async {
    emit(state.copyWith(status: BudgetStatus.loading));
    try {
      final budget = await _budgetManager.getMonthlyBudget(
        event.year,
        event.month,
      );
      final stats = await _budgetManager.getBudgetStats(
        event.year,
        event.month,
      );
      emit(state.copyWith(
        status: BudgetStatus.success,
        budget: budget,
        stats: stats,
      ));
    } catch (e) {
      emit(state.copyWith(status: BudgetStatus.failure));
    }
  }

  void _onSetBudget(SetBudget event, Emitter<BudgetState> emit) async {
    try {
      final budget = await _budgetManager.setBudget(
        event.year,
        event.month,
        event.amount,
      );
      final stats = await _budgetManager.getBudgetStats(
        event.year,
        event.month,
      );
      emit(state.copyWith(
        status: BudgetStatus.success,
        budget: budget,
        stats: stats,
      ));
    } catch (e) {
      // Handle error
    }
  }
}
