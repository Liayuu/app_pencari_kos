import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import '../controllers/notification_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;

  bool _isDarkMode = false;
  bool _isNotificationsEnabled = true;
  bool _isLocationEnabled = true;
  double _searchRadius = 5.0;
  String _language = 'Bahasa Indonesia';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    // Load preferences from SharedPreferences or default values
    setState(() {
      _isDarkMode = false; // default value
      _isNotificationsEnabled = true; // default value
      _language = 'Bahasa Indonesia'; // default value
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Akun'),
            Tab(icon: Icon(Icons.settings), text: 'Aplikasi'),
            Tab(icon: Icon(Icons.security), text: 'Privasi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAccountTab(),
          _buildAppSettingsTab(),
          _buildPrivacyTab(),
        ],
      ),
    );
  }

  Widget _buildAccountTab() {
    return Consumer<UserController>(
      builder: (context, userController, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Card with AnimatedContainer
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      safeOpacity(Theme.of(context).primaryColor, 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: safeOpacity(Colors.black, 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Text(
                        userController.name.substring(0, 1),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userController.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            userController.email,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Account Options
              _buildSectionTitle('Informasi Akun'),

              ExpansionTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Profil'),
                subtitle: const Text('Ubah nama, email, dan foto profil'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Nama Lengkap',
                            prefixIcon: Icon(Icons.person),
                          ),
                          initialValue: userController.name,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                          initialValue: userController.email,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Flexible(
                              child: ElevatedButton(
                                onPressed: () {
                                  _showSaveConfirmation();
                                },
                                child: const Text('Simpan'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    // Reset form
                                  });
                                },
                                child: const Text('Batal'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              ExpansionTile(
                leading: const Icon(Icons.lock),
                title: const Text('Keamanan'),
                subtitle: const Text('Ubah password dan pengaturan keamanan'),
                children: [
                  ListTile(
                    leading: const Icon(Icons.vpn_key),
                    title: const Text('Ubah Password'),
                    onTap: _showChangePasswordDialog,
                  ),
                  ListTile(
                    leading: const Icon(Icons.fingerprint),
                    title: const Text('Autentikasi Biometrik'),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        // Toggle biometric auth
                      },
                    ),
                  ),
                ],
              ),

              ExpansionTile(
                leading: const Icon(Icons.history),
                title: const Text('Riwayat Aktivitas'),
                subtitle: const Text('Lihat riwayat pencarian dan booking'),
                children: [
                  ListTile(
                    leading: const Icon(Icons.search),
                    title: const Text('Riwayat Pencarian'),
                    onTap: () {
                      _showHistoryDialog('Pencarian');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.book),
                    title: const Text('Riwayat Booking'),
                    onTap: () {
                      _showHistoryDialog('Booking');
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Tampilan'),

          // Dark Mode with AnimatedContainer
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isDarkMode ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: _isDarkMode ? Colors.white : Colors.black87,
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mode Gelap',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        'Menggunakan tema gelap untuk kenyamanan mata',
                        style: TextStyle(
                          fontSize: 12,
                          color: _isDarkMode ? Colors.white70 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Language Selection
          ExpansionTile(
            leading: const Icon(Icons.language),
            title: const Text('Bahasa'),
            subtitle: Text(_language),
            children: [
              RadioListTile<String>(
                title: const Text('Bahasa Indonesia'),
                value: 'Bahasa Indonesia',
                groupValue: _language,
                onChanged: (value) async {
                  setState(() {
                    _language = value!;
                  });
                  // Save to SharedPreferences or other storage
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Bahasa diubah ke $value'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('English'),
                value: 'English',
                groupValue: _language,
                onChanged: (value) async {
                  setState(() {
                    _language = value!;
                  });
                  // Save to SharedPreferences or other storage
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Language changed to $value'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('Notifikasi'),

          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Aktifkan Notifikasi'),
            subtitle: const Text('Terima notifikasi untuk update penting'),
            value: _isNotificationsEnabled,
            onChanged: (value) async {
              setState(() {
                _isNotificationsEnabled = value;
              });
              // Save to SharedPreferences or other storage
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? 'Notifikasi diaktifkan'
                          : 'Notifikasi dinonaktifkan',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('Lokasi'),

          SwitchListTile(
            secondary: const Icon(Icons.location_on),
            title: const Text('Akses Lokasi'),
            subtitle: const Text('Gunakan lokasi untuk pencarian kos terdekat'),
            value: _isLocationEnabled,
            onChanged: (value) {
              setState(() {
                _isLocationEnabled = value;
              });
            },
          ),

          if (_isLocationEnabled) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Radius Pencarian',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Slider(
                          value: _searchRadius,
                          min: 1.0,
                          max: 20.0,
                          divisions: 19,
                          label: '${_searchRadius.toInt()} km',
                          onChanged: (value) {
                            setState(() {
                              _searchRadius = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          '${_searchRadius.toInt()} km',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),
          _buildSectionTitle('Data & Storage'),

          ExpansionTile(
            leading: const Icon(Icons.storage),
            title: const Text('Kelola Data'),
            subtitle: const Text('Hapus cache dan data tersimpan'),
            children: [
              ListTile(
                leading: const Icon(Icons.delete_sweep),
                title: const Text('Hapus Cache'),
                subtitle: const Text('Menghapus data cache aplikasi'),
                onTap: _showClearCacheDialog,
              ),
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Download Data'),
                subtitle: const Text('Download data personal Anda'),
                onTap: _showDownloadDataDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyTab() {
    return Consumer<NotificationController>(
      builder: (context, notificationController, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Privasi & Keamanan'),

              ExpansionTile(
                leading: const Icon(Icons.visibility),
                title: const Text('Pengaturan Visibilitas'),
                subtitle: const Text(
                  'Kontrol siapa yang dapat melihat profil Anda',
                ),
                children: [
                  CheckboxListTile(
                    title: const Text('Profil Publik'),
                    subtitle: const Text(
                      'Izinkan pengguna lain melihat profil Anda',
                    ),
                    value: true,
                    onChanged: (value) {
                      // Toggle profile visibility
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Tampilkan Status Online'),
                    subtitle: const Text(
                      'Tampilkan kapan terakhir Anda online',
                    ),
                    value: false,
                    onChanged: (value) {
                      // Toggle online status
                    },
                  ),
                ],
              ),

              ExpansionTile(
                leading: const Icon(Icons.block),
                title: const Text('Pemblokiran'),
                subtitle: const Text('Kelola pengguna yang diblokir'),
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_off),
                    title: const Text('Daftar Pengguna Diblokir'),
                    subtitle: const Text('0 pengguna diblokir'),
                    onTap: () {
                      _showBlockedUsersDialog();
                    },
                  ),
                ],
              ),

              ExpansionTile(
                leading: const Icon(Icons.report),
                title: const Text('Laporan & Masalah'),
                subtitle: const Text(
                  'Laporkan masalah atau konten yang tidak pantas',
                ),
                children: [
                  ListTile(
                    leading: const Icon(Icons.bug_report),
                    title: const Text('Laporkan Bug'),
                    onTap: () {
                      _showReportDialog('Bug');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.report_problem),
                    title: const Text('Laporkan Konten'),
                    onTap: () {
                      _showReportDialog('Konten');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('Legal'),

              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Syarat & Ketentuan'),
                onTap: () {
                  _showLegalDialog('Syarat & Ketentuan');
                },
              ),

              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Kebijakan Privasi'),
                onTap: () {
                  _showLegalDialog('Kebijakan Privasi');
                },
              ),

              const SizedBox(height: 32),

              // Danger Zone
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Zona Berbahaya',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tindakan di bawah ini tidak dapat dibatalkan.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            onPressed: _showDeleteAccountDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Hapus Akun'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  void _showSaveConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Simpan Perubahan'),
          content: const Text('Apakah Anda yakin ingin menyimpan perubahan?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profil berhasil diperbarui'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ubah Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password Lama',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password Baru',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password berhasil diubah'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Ubah'),
            ),
          ],
        );
      },
    );
  }

  void _showHistoryDialog(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Riwayat $type'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    type == 'Pencarian' ? Icons.search : Icons.home,
                  ),
                  title: Text('$type ${index + 1}'),
                  subtitle: Text('2 hari yang lalu'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                );
              },
            ),
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

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Cache'),
          content: const Text(
            'Menghapus cache akan meningkatkan performa aplikasi. '
            'Data login Anda tidak akan terhapus.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache berhasil dihapus'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _showDownloadDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Download Data'),
          content: const Text(
            'Kami akan mengirimkan file berisi data personal Anda ke email terdaftar dalam 24 jam.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Permintaan download berhasil dikirim'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: const Text('Download'),
            ),
          ],
        );
      },
    );
  }

  void _showBlockedUsersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pengguna Diblokir'),
          content: const Text('Tidak ada pengguna yang diblokir saat ini.'),
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

  void _showReportDialog(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Laporkan $type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Subjek',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi masalah',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Laporan berhasil dikirim'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );
  }

  void _showLegalDialog(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
              'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris...\n\n'
              'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore...',
              style: TextStyle(height: 1.5),
            ),
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

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Akun', style: TextStyle(color: Colors.red)),
          content: const Text(
            'PERINGATAN: Menghapus akun akan menghapus semua data Anda secara permanen. '
            'Tindakan ini tidak dapat dibatalkan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Show confirmation dialog
                _showFinalDeleteConfirmation();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus Akun'),
            ),
          ],
        );
      },
    );
  }

  void _showFinalDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Terakhir'),
          content: const Text(
            'Ketik "HAPUS AKUN" untuk mengonfirmasi penghapusan akun.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Akun berhasil dihapus'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Konfirmasi'),
            ),
          ],
        );
      },
    );
  }

  Color safeOpacity(Color color, double opacity) {
    if (opacity.isNaN) opacity = 1.0;
    if (opacity < 0.0) opacity = 0.0;
    if (opacity > 1.0) opacity = 1.0;
    return color.withOpacity(opacity);
  }
}
