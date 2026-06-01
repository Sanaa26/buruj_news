import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppFlavor { dev, prod }

class AppConfig {
  final AppFlavor flavor;
  final String appName;
  final String apiBaseUrl;
  final String newsApiKey;
  final bool showDebugBanner;

  AppConfig({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.newsApiKey,
    this.showDebugBanner = false,
  });

  static AppConfig? _instance;

  static void setInstance(AppConfig config) {
    _instance = config;
  }

  static bool get isInitialized => _instance != null;

  static AppConfig get instance {
    if (_instance == null) {
      throw StateError("AppConfig has not been initialized. Please set instance before accessing.");
    }
    return _instance!;
  }
}

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.instance;
});
