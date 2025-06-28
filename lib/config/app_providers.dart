import 'package:provider/provider.dart';
import '../controllers/kos_controller.dart';
import '../controllers/user_controller.dart';
import '../controllers/search_controller.dart' as search_ctrl;
import '../controllers/notification_controller.dart';

class AppProviders {
  static List<ChangeNotifierProvider> get providers {
    return [
      ChangeNotifierProvider(create: (_) => KosController()..initializeData()),
      ChangeNotifierProvider(create: (_) => UserController()),
      ChangeNotifierProvider(create: (_) => search_ctrl.SearchController()),
      ChangeNotifierProvider(create: (_) => NotificationController()),
    ];
  }
}
