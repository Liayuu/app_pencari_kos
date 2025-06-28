import 'package:flutter/material.dart';
import '../screens/advanced_kos_screen.dart';
import '../screens/add_kos_form_screen.dart';
import '../screens/bookmarks_wrapper_screen.dart';
import '../screens/search_wrapper_screen.dart';

/// Widget collection for various menu buttons used throughout the app
class MenuButtons {
  /// App Bar action buttons for Home Screen
  static List<Widget> homeAppBarActions(BuildContext context) {
    return [
      // Search button
      IconButton(
        icon: const Icon(Icons.search),
        tooltip: 'Cari Kos',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchWrapperScreen(),
            ),
          );
        },
      ),
      // Bookmark button
      IconButton(
        icon: const Icon(Icons.bookmark),
        tooltip: 'Bookmark Saya',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BookmarksWrapperScreen(),
            ),
          );
        },
      ),
    ];
  }

  /// Bottom navigation items for MainNavigationScreen
  static List<Widget> bottomNavigationItems() {
    return const [
      Icon(Icons.home, size: 30, color: Colors.white),
      Icon(Icons.search, size: 30, color: Colors.white),
      Icon(Icons.map, size: 30, color: Colors.white),
      Icon(Icons.bookmark, size: 30, color: Colors.white),
      Icon(Icons.person, size: 30, color: Colors.white),
    ];
  }

  /// Floating action button for bookmark sharing
  static Widget bookmarkShareButton(
    BuildContext context,
    VoidCallback onPressed,
  ) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: 'Bagikan Semua Bookmark',
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.share, color: Colors.white),
    );
  }

  /// Floating action button for location
  static Widget locationButton(BuildContext context, VoidCallback onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: 'Lokasi Saya',
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.my_location, color: Colors.white),
    );
  }

  /// Floating action button for advanced search
  static Widget advancedSearchButton(
    BuildContext context,
    VoidCallback onPressed,
  ) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      label: const Text('Pencarian Lanjutan'),
      icon: const Icon(Icons.tune),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
    );
  }

  /// Menu tile for drawer navigation
  static Widget drawerMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    int delay = 0,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.blue[600], size: 28),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      onTap: onTap,
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
    );
  }

  /// Photo upload button for forms
  static Widget photoUploadButton({
    required VoidCallback onTap,
    String label = 'Tambah Foto',
    String subtitle = '',
    double height = 120,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[50],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  /// Profile photo change button
  static Widget profilePhotoButton({
    required VoidCallback onTap,
    String? imagePath,
    double size = 120,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!, width: 2),
          color: Colors.grey[100],
        ),
        child: imagePath != null && imagePath.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(size / 2),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _defaultProfileIcon(size);
                  },
                ),
              )
            : _defaultProfileIcon(size),
      ),
    );
  }

  /// Helper method for default profile icon
  static Widget _defaultProfileIcon(double size) {
    return Icon(Icons.person, size: size * 0.6, color: Colors.grey[400]);
  }

  /// Quick action buttons for home screen
  static List<Widget> quickActionButtons(BuildContext context) {
    return [
      _quickActionCard(
        context,
        icon: Icons.search,
        title: 'Cari Kos',
        subtitle: 'Temukan kos impian',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchWrapperScreen()),
        ),
      ),
      _quickActionCard(
        context,
        icon: Icons.apartment,
        title: 'Kos Premium',
        subtitle: 'Lihat kos terbaik',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdvancedKosScreen()),
        ),
      ),
      _quickActionCard(
        context,
        icon: Icons.add_business,
        title: 'Daftar Kos',
        subtitle: 'Tambahkan kos Anda',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddKosFormScreen()),
        ),
      ),
      _quickActionCard(
        context,
        icon: Icons.bookmark,
        title: 'Bookmark',
        subtitle: 'Kos tersimpan',
        onTap: () {
          // Navigate to bookmark tab in MainNavigationScreen
          if (Navigator.canPop(context)) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
          // Show message to use bottom tab
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Gunakan tab bookmark di bawah untuk melihat kos tersimpan',
              ),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    ];
  }

  /// Helper method for quick action card
  static Widget _quickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(icon, size: 32, color: Theme.of(context).primaryColor),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Help and support buttons
  static List<Widget> supportButtons(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.help_outline, color: Colors.blue),
        title: const Text('FAQ'),
        subtitle: const Text('Pertanyaan yang sering diajukan'),
        onTap: () => _showComingSoon(context, 'FAQ'),
      ),
      ListTile(
        leading: const Icon(Icons.chat, color: Colors.green),
        title: const Text('Live Chat'),
        subtitle: const Text('Chat dengan customer service'),
        onTap: () => _showComingSoon(context, 'Live Chat'),
      ),
      ListTile(
        leading: const Icon(Icons.phone, color: Colors.orange),
        title: const Text('Hubungi Kami'),
        subtitle: const Text('Telepon customer service'),
        onTap: () => _showComingSoon(context, 'Hubungi Kami'),
      ),
    ];
  }

  /// Helper method to show coming soon dialog
  static void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$feature Segera Hadir'),
          content: Text(
            'Fitur $feature sedang dalam pengembangan dan akan segera tersedia.',
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
}
