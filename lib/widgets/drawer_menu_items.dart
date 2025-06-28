import 'package:flutter/material.dart';
import '../screens/advanced_kos_screen.dart';
import '../screens/add_kos_form_screen.dart';
import '../screens/settings_screen.dart';

/// Drawer menu configuration and items
class DrawerMenuItems {
  /// Get all main drawer menu items
  static List<DrawerMenuItem> getMainMenuItems() {
    return [
      DrawerMenuItem(
        icon: Icons.dashboard,
        title: 'Dashboard',
        subtitle: 'Ringkasan aktivitas',
        onTap: (context) => Navigator.pop(context),
        delay: 100,
      ),
      DrawerMenuItem(
        icon: Icons.apartment,
        title: 'Kos Advanced',
        subtitle: 'Fitur pencarian lanjutan',
        onTap: (context) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdvancedKosScreen()),
          );
        },
        delay: 150,
      ),
      DrawerMenuItem(
        icon: Icons.bookmark,
        title: 'Bookmark Saya',
        subtitle: 'Kos yang disimpan',
        onTap: (context) {
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
      DrawerMenuItem(
        icon: Icons.add_business,
        title: 'Tambah Kos',
        subtitle: 'Daftarkan kos Anda',
        onTap: (context) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddKosFormScreen()),
          );
        },
        delay: 250,
      ),
    ];
  }

  /// Get secondary drawer menu items
  static List<DrawerMenuItem> getSecondaryMenuItems() {
    return [
      DrawerMenuItem(
        icon: Icons.book_online,
        title: 'Riwayat Booking',
        subtitle: 'Transaksi dan pesanan',
        onTap: (context) {
          Navigator.pop(context);
          _showComingSoon(context, 'Riwayat Booking');
        },
        delay: 300,
      ),
      DrawerMenuItem(
        icon: Icons.payment,
        title: 'Pembayaran',
        subtitle: 'Kelola metode pembayaran',
        onTap: (context) {
          Navigator.pop(context);
          _showComingSoon(context, 'Pembayaran');
        },
        delay: 350,
      ),
      DrawerMenuItem(
        icon: Icons.support_agent,
        title: 'Bantuan & Support',
        subtitle: 'Hubungi customer service',
        onTap: (context) {
          Navigator.pop(context);
          _showSupportDialog(context);
        },
        delay: 400,
      ),
      DrawerMenuItem(
        icon: Icons.settings,
        title: 'Pengaturan',
        subtitle: 'Preferensi aplikasi',
        onTap: (context) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        },
        delay: 450,
      ),
    ];
  }

  /// Get footer menu items
  static List<DrawerMenuItem> getFooterMenuItems() {
    return [
      DrawerMenuItem(
        icon: Icons.info_outline,
        title: 'Tentang Aplikasi',
        subtitle: 'Versi 1.0.0',
        onTap: (context) {
          Navigator.pop(context);
          _showAboutDialog(context);
        },
        delay: 500,
      ),
      DrawerMenuItem(
        icon: Icons.logout,
        title: 'Keluar',
        subtitle: 'Logout dari aplikasi',
        onTap: (context) {
          Navigator.pop(context);
          _showLogoutDialog(context);
        },
        delay: 550,
        isDestructive: true,
      ),
    ];
  }

  /// Show coming soon dialog
  static void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$feature Segera Hadir'),
          content: Text(
            'Fitur $feature sedang dalam pengembangan dan akan segera tersedia dalam update mendatang.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Show support dialog
  static void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bantuan & Support'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hubungi kami melalui:'),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.email, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('support@bosskost.com'),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.green),
                  SizedBox(width: 8),
                  Text('0800-1234-5678'),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.chat, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('WhatsApp: 0812-3456-7890'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  /// Show about dialog
  static void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Boss Kost',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.home, size: 32),
      children: const [
        Text(
          'Boss Kost adalah aplikasi pencarian kos terbaik yang membantu Anda menemukan hunian yang nyaman dan sesuai budget.',
        ),
      ],
    );
  }

  /// Show logout confirmation dialog
  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement logout logic
                _showComingSoon(context, 'Logout');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}

/// Data model for drawer menu item
class DrawerMenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Function(BuildContext context) onTap;
  final int delay;
  final bool isDestructive;
  final Color? iconColor;

  DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.delay = 0,
    this.isDestructive = false,
    this.iconColor,
  });

  /// Build the list tile widget for this menu item
  Widget buildTile(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + delay),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive
              ? Colors.red[600]
              : iconColor ?? Theme.of(context).primaryColor,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDestructive ? Colors.red[600] : null,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        onTap: () => onTap(context),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDestructive ? Colors.red[400] : Colors.grey,
        ),
      ),
    );
  }
}
