import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_config.dart';
import 'presentation/news_screen.dart';
import 'providers/theme_provider.dart';

void main() {
  if (!AppConfig.isInitialized) {
    const flavorStr = String.fromEnvironment('FLAVOR', defaultValue: 'prod');
    final flavor = flavorStr == 'dev' ? AppFlavor.dev : AppFlavor.prod;
    AppConfig.setInstance(
      AppConfig(
        flavor: flavor,
        appName: flavor == AppFlavor.dev ? "Buruj News Dev" : "Buruj News",
        apiBaseUrl: "https://newsapi.org",
        newsApiKey: "6139379870bf4f449beecab24aa8cd04",
        showDebugBanner: flavor == AppFlavor.dev,
      ),
    );
  }
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final config = ref.watch(appConfigProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: config.showDebugBanner,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: NewsScreen(),
    );
  }
}