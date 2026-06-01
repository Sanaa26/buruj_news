import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() => false; // false = light, true = dark

  void setTheme(bool isDark) {
    state = isDark;
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, bool>(() {
  return ThemeNotifier();
});
