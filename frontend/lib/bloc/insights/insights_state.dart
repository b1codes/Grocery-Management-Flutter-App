import 'package:grocery_management_frontend/models/insight.dart';

enum InsightsStatus { initial, loading, success, failure }

class InsightsState {
  final List<Insight> insights;
  final InsightsStatus status;

  const InsightsState({
    this.insights = const [],
    this.status = InsightsStatus.initial,
  });

  InsightsState copyWith({List<Insight>? insights, InsightsStatus? status}) {
    return InsightsState(
      insights: insights ?? this.insights,
      status: status ?? this.status,
    );
  }
}
