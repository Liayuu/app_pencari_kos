import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../widgets/menu_buttons.dart';
import '../screens/home_screen.dart';
import '../screens/search_wrapper_screen.dart';
import '../screens/map_screen.dart';
import '../screens/bookmarks_wrapper_screen.dart';
import '../screens/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> get _screens => [
    const HomeScreen(),
    const SearchWrapperScreen(),
    const MapScreen(),
    const BookmarksWrapperScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 65,
        items: MenuButtons.bottomNavigationItems(),
        color: Theme.of(context).primaryColor,
        buttonBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: _onTabTapped,
      ),
    );
  }
}
