import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/provider_wrapper_screen.dart';
import '../screens/advanced_kos_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String main = '/main';
  static const String home = '/home';
  static const String advanced = '/advanced';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes {
    return {
      main: (context) => const ProviderWrapperScreen(),
      home: (context) => const HomeScreen(),
      advanced: (context) => const AdvancedKosScreen(),
      settings: (context) => const SettingsScreen(),
    };
  }
}
