import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'config/app_routes.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BossKostApp());
}

class BossKostApp extends StatelessWidget {
  const BossKostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boss Kost',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: AppRoutes.routes,
    );
  }
}
