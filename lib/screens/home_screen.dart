import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/advanced_drawer.dart';
import '../widgets/menu_buttons.dart';
import '../controllers/user_controller.dart';
import '../controllers/kos_controller.dart';
import 'search_wrapper_screen.dart';
import 'bookmarks_wrapper_screen.dart';
import '../widgets/kos_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const AdvancedDrawer(),
      body: Consumer2<UserController, KosController>(
        builder: (context, userController, kosController, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row: BOSS KOST + Notif + Drawer
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'BOSS KOST',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            size: 28,
                          ),
                          onPressed: () {
                            // TODO: Navigasi ke notifikasi jika ada
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.menu, size: 28),
                          onPressed: () {
                            _scaffoldKey.currentState?.openEndDrawer();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Welcome Section
                _buildWelcomeSection(userController),

                const SizedBox(height: 20),

                // Search Bar
                _buildSearchBar(kosController),

                const SizedBox(height: 20),

                // Quick Stats
                _buildQuickStats(userController),

                const SizedBox(height: 20),

                // Quick Actions
                _buildQuickActions(),

                const SizedBox(height: 20),

                // Daftar Kos (Featured)
                _buildKosList(kosController),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(UserController userController) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            safeOpacity(Theme.of(context).primaryColor, 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat Datang!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userController.name,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Temukan kos impian Anda hari ini',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: safeOpacity(Colors.white, 0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.home, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(KosController kosController) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari kos, alamat, atau fasilitas...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) {
        kosController.searchKos(value);
      },
    );
  }

  Widget _buildQuickStats(UserController userController) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Kos',
            '0', // Static data for now
            Icons.home_work,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Bookmark',
            userController.favoriteCount.toString(),
            Icons.bookmark,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Booking',
            userController.bookingCount.toString(),
            Icons.book_online,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: safeOpacity(Colors.grey, 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aksi Cepat',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Cari Kos',
                'Temukan kos sesuai kriteria',
                Icons.search,
                Colors.blue,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchWrapperScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Bookmark',
                'Lihat kos bookmark Anda',
                Icons.bookmark,
                Colors.orange,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookmarksWrapperScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: safeOpacity(color, 0.2)),
          boxShadow: [
            BoxShadow(
              color: safeOpacity(Colors.grey, 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKosList(KosController kosController) {
    final kosList = kosController.filteredKos;
    if (kosList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: Text('Tidak ada kos ditemukan.')),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rekomendasi Kos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: kosList.length > 5 ? 5 : kosList.length,
          itemBuilder: (context, index) {
            final kos = kosList[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: KosCard(
                kos: kos,
                onTap: () {
                  // Navigasi ke detail kos jika ada
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

Color safeOpacity(Color color, double opacity) {
  if (opacity.isNaN) opacity = 1.0;
  if (opacity < 0.0) opacity = 0.0;
  if (opacity > 1.0) opacity = 1.0;
  return color.withOpacity(opacity);
}
