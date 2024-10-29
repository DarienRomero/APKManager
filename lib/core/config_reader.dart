import 'dart:convert';
import 'package:flutter/services.dart';

abstract class ConfigReader {
  static Map<String, dynamic>? _config;

  static Future<void> initialize() async {
    final configString = await rootBundle.loadString('config/app_config.json');
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  static String getSecretKey() {
    return _config?['secretKey'] as String? ?? "";
  }
  static String getAppName() {
    return _config?['appName'] as String? ?? "";
  }
}