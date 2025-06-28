import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import '../controllers/kos_controller.dart';
import '../controllers/search_controller.dart' as search_ctrl;
import '../controllers/notification_controller.dart';
import 'bookmarks_screen.dart';

/// Wrapper screen for BookmarksScreen with provider support
/// This allows BookmarksScreen to be navigated to directly while maintaining provider access
class BookmarksWrapperScreen extends StatelessWidget {
  const BookmarksWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => KosController()..initializeData(),
        ),
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => search_ctrl.SearchController()),
        ChangeNotifierProvider(create: (_) => NotificationController()),
      ],
      child: const BookmarksScreen(),
    );
  }
}
