import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class AppConfig {
  static Map<String, dynamic> _config = {};
  static String baseUrl = '';

  static Future<void> load(String env) async {
    try {
      final String configString = await rootBundle.loadString('envs/$env.json');
      _config = json.decode(configString);
      baseUrl = _config['BASE_URL'] ?? '';
    } catch (e) {
      debugPrint('Warning: Could not load config for $env. Using defaults.');
      // Initialize with defaults if needed
    }
  }

  static dynamic get(String key) => _config[key];
}