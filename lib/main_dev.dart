import 'app_config.dart';
import 'main.dart' as common_main;

void main() {
  AppConfig.setInstance(
    AppConfig(
      flavor: AppFlavor.dev,
      appName: "Buruj News Dev",
      apiBaseUrl: "https://newsapi.org",
      newsApiKey: "6139379870bf4f449beecab24aa8cd04",
      showDebugBanner: true,
    ),
  );
  
  common_main.main();
}
