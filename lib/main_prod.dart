import 'app_config.dart';
import 'main.dart' as common_main;

void main() {
  AppConfig.setInstance(
    AppConfig(
      flavor: AppFlavor.prod,
      appName: "Buruj News",
      apiBaseUrl: "https://newsapi.org",
      newsApiKey: "6139379870bf4f449beecab24aa8cd04",
      showDebugBanner: false,
    ),
  );
  
  common_main.main();
}
