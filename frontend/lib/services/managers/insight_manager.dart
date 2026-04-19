import 'dart:developer' as developer;
import 'package:grocery_management_frontend/models/insight.dart';
import 'package:grocery_management_frontend/networking/api/insight_api.dart';

class InsightManager {
  final InsightApi _insightApi;

  InsightManager({InsightApi? insightApi}) : _insightApi = insightApi ?? InsightApi();

  Future<List<Insight>> getNutritionalRecommendations() async {
    try {
      final response = await _insightApi.getInsights();
      final List<dynamic> data = response.data['recommendations'];
      return data.map((e) => InsightMapper.fromMap(e)).toList();
    } catch (e, stackTrace) {
      developer.log('Error getting nutritional recommendations', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
