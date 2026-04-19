import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_management_frontend/services/managers/insight_manager.dart';
import 'insights_event.dart';
import 'insights_state.dart';

export 'insights_event.dart';
export 'insights_state.dart';

class InsightsBloc extends Bloc<InsightsEvent, InsightsState> {
  final InsightManager _insightManager;

  InsightsBloc({required InsightManager insightManager})
    : _insightManager = insightManager,
      super(const InsightsState()) {
    on<FetchInsights>(_onFetchInsights);
  }

  void _onFetchInsights(FetchInsights event, Emitter<InsightsState> emit) async {
    emit(state.copyWith(status: InsightsStatus.loading));
    try {
      final insights = await _insightManager.getNutritionalRecommendations();
      emit(state.copyWith(status: InsightsStatus.success, insights: insights));
    } catch (e) {
      emit(state.copyWith(status: InsightsStatus.failure));
    }
  }
}
