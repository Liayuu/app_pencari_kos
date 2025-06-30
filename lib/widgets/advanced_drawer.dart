import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import '../screens/advanced_kos_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/add_kos_form_screen.dart';

class AdvancedDrawer extends StatefulWidget {
  const AdvancedDrawer({super.key});

  @override
  State<AdvancedDrawer> createState() => _AdvancedDrawerState();
}

class _AdvancedDrawerState extends State<AdvancedDrawer>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _slideController.forward();
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userController, child) {
        return Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  Colors.white,
                ],
              ),
            ),
            child: Column(
              children: [
                // Advanced Header Section
                SlideTransition(
                  position: _slideAnimation,
                  child: _buildAdvancedHeader(userController),
                ),

                // Main Menu Items
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: [
                        _buildAnimatedListTile(
                          icon: Icons.dashboard,
                          title: 'Dashboard',
                          subtitle: 'Ringkasan aktivitas',
                          onTap: () => Navigator.pop(context),
                          delay: 100,
                        ),

                        _buildAnimatedListTile(
                          icon: Icons.apartment,
                          title: 'Kos Advanced',
                          subtitle: 'Fitur pencarian lanjutan',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdvancedKosScreen(),
                              ),
                            );
                          },
                          delay: 150,
                        ),

                        _buildAnimatedListTile(
                          icon: Icons.bookmark,
                          title: 'Bookmark Saya',
                          subtitle:
                              '${userController.favoriteCount} kos disimpan',
                          onTap: () {
                            Navigator.pop(context);
                            // Show message to use bottom tab instead of direct navigation
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Gunakan tab bookmark di bawah untuk melihat kos tersimpan',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          delay: 200,
                        ),

                        _buildAnimatedListTile(
                          icon: Icons.add_business,
                          title: 'Tambah Kos',
                          subtitle: 'Daftarkan kos Anda',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddKosFormScreen(),
                              ),
                            );
                          },
                          delay: 250,
                        ),

                        const Divider(height: 32),

                        _buildAnimatedListTile(
                          icon: Icons.book_online,
                          title: 'Riwayat Booking',
                          subtitle: '${userController.bookingCount} transaksi',
                          onTap: () {
                            Navigator.pop(context);
                            _showComingSoon(context, 'Riwayat Booking');
                          },
                          delay: 300,
                        ),

                        _buildAnimatedListTile(
                          icon: Icons.payment,
                          title: 'Pembayaran',
                          subtitle: 'Kelola metode pembayaran',
                          onTap: () {
                            Navigator.pop(context);
                            _showComingSoon(context, 'Pembayaran');
                          },
                          delay: 350,
                        ),

                        _buildAnimatedListTile(
                          icon: Icons.support_agent,
                          title: 'Bantuan & Support',
                          subtitle: 'Hubungi customer service',
                          onTap: () {
                            Navigator.pop(context);
                            _showSupportDialog(context);
                          },
                          delay: 400,
                        ),

                        _buildAnimatedListTile(
                          icon: Icons.settings,
                          title: 'Pengaturan',
                          subtitle: 'Preferensi aplikasi',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          },
                          delay: 450,
                        ),

                        const Divider(height: 32),

                        _buildAnimatedListTile(
                          icon: Icons.info_outline,
                          title: 'Tentang Aplikasi',
                          subtitle: 'Versi 1.0.0',
                          onTap: () {
                            Navigator.pop(context);
                            _showAboutDialog(context);
                          },
                          delay: 500,
                        ),
                      ],
                    ),
                  ),
                ),

                // Logout Section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _showLogoutDialog(context, userController),
                        icon: const Icon(Icons.logout),
                        label: const Text('Keluar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdvancedHeader(UserController userController) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close Button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(height: 10),

                // Profile Section
                Row(
                  children: [
                    // Profile Picture with Animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        color: safeOpacity(Colors.white, 0.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: userController.profileImagePath.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.asset(
                                userController.profileImagePath,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                    ),

                    const SizedBox(width: 16),

                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userController.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userController.email,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Premium User',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Stats Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatCard(
                        'Bookmark',
                        userController.favoriteCount.toString(),
                        Icons.bookmark,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        'Booking',
                        userController.bookingCount.toString(),
                        Icons.book_online,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard('Poin', '1,250', Icons.stars),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: safeOpacity(Colors.white, 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: safeOpacity(Colors.white, 0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - value), 0),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0), // Clamp opacity to valid range
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: safeOpacity(Colors.white, 0.7),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: safeOpacity(Theme.of(context).primaryColor, 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
                title: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: onTap,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: Text(
          'Fitur $feature akan segera tersedia dalam update mendatang.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bantuan & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hubungi kami melalui:'),
            SizedBox(height: 8),
            Text('📧 Email: support@bosskost.com'),
            Text('📱 WhatsApp: +62 812 3456 7890'),
            Text('⏰ Jam Operasional: 08:00 - 22:00'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Open WhatsApp or email
            },
            child: const Text('Hubungi'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Boss Kost',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.home, color: Colors.white, size: 30),
      ),
      children: const [
        Text(
          'Boss Kost adalah aplikasi pencarian kos terbaik di Indonesia. Temukan kos impian Anda dengan mudah dan cepat.',
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, UserController userController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              userController.logout();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Berhasil keluar dari aplikasi'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  Color safeOpacity(Color color, double opacity) {
    if (opacity.isNaN) opacity = 1.0;
    if (opacity < 0.0) opacity = 0.0;
    if (opacity > 1.0) opacity = 1.0;
    return color.withOpacity(opacity);
  }
}
