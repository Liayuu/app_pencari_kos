import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/kos_controller.dart';
import 'controllers/search_controller.dart' as custom;
import 'controllers/user_controller.dart';
import 'controllers/notification_controller.dart';
import 'config/app_theme.dart';
import 'config/app_routes.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KosController()),
        ChangeNotifierProvider(create: (_) => custom.SearchController()),
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => NotificationController()),
      ],
      child: const BossKostApp(),
    ),
  );
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
