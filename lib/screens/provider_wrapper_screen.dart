import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import '../controllers/kos_controller.dart';
import '../controllers/search_controller.dart' as search_ctrl;
import '../controllers/notification_controller.dart';
import 'main_navigation_screen.dart';

class ProviderWrapperScreen extends StatefulWidget {
  const ProviderWrapperScreen({super.key});

  @override
  State<ProviderWrapperScreen> createState() => _ProviderWrapperScreenState();
}

class _ProviderWrapperScreenState extends State<ProviderWrapperScreen> {
  late KosController _kosController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _kosController = KosController();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      _kosController.initializeData();
      await _kosController.loadFavorites();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      // Handle initialization error
      debugPrint('Error initializing data: $e');
      if (mounted) {
        setState(() {
          _isInitialized = true; // Still show UI even if favorites fail
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Memuat data...'),
            ],
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _kosController),
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => search_ctrl.SearchController()),
        ChangeNotifierProvider(create: (_) => NotificationController()),
      ],
      child: const MainNavigationScreen(),
    );
  }
}
