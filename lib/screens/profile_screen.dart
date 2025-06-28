import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Inisialisasi controller setelah provider tersedia
    if (_nameController.text.isEmpty) {
      final userController = Provider.of<UserController>(
        context,
        listen: false,
      );
      _nameController.text = userController.name;
      _emailController.text = userController.email;
      _phoneController.text = userController.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userController = Provider.of<UserController>(
        context,
        listen: false,
      );

      // Validate data before saving
      if (!userController.validateProfileData()) {
        throw Exception('Data profil tidak valid');
      }

      // Update data in controller
      userController.updateName(_nameController.text.trim());
      userController.updateEmail(_emailController.text.trim().toLowerCase());
      userController.updatePhone(_phoneController.text.trim());

      // Save to API/Database
      bool success = await userController.saveProfile();

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Profil berhasil disimpan!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          _isEditing = false;
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('Gagal menyimpan profil. Coba lagi.'),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Error: $e')),
              ],
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _changeProfilePhoto() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur galeri akan segera tersedia'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur kamera akan segera tersedia'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userController, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil'),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            actions: [
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              else
                TextButton(
                  onPressed: () {
                    if (_isEditing) {
                      _saveProfile();
                    } else {
                      setState(() {
                        _isEditing = true;
                      });
                    }
                  },
                  child: Text(
                    _isEditing ? 'Simpan' : 'Edit',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                color: Colors.white.withOpacity(0.3),
                              ),
                              child: userController.profileImagePath.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        userController.profileImagePath,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.person,
                                                size: 50,
                                                color: Colors.white,
                                              );
                                            },
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                            ),
                            if (_isEditing)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _changeProfilePhoto,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userController.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userController.email,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem(
                              'Bookmark',
                              userController.favoriteCount.toString(),
                            ),
                            _buildStatItem(
                              'Booking',
                              userController.bookingCount.toString(),
                            ),
                            _buildStatItem('Poin', '1,250'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Profile Information
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Pribadi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Name Field
                        _buildProfileField(
                          'Nama Lengkap',
                          _nameController,
                          Icons.person,
                        ),
                        const SizedBox(height: 16),

                        // Email Field
                        _buildProfileField(
                          'Email',
                          _emailController,
                          Icons.email,
                        ),
                        const SizedBox(height: 16),

                        // Phone Field
                        _buildProfileField(
                          'Nomor Telepon',
                          _phoneController,
                          Icons.phone,
                        ),

                        const SizedBox(height: 32),

                        // Statistics Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                userController.favoriteCount.toString(),
                                'Kos Disimpan',
                                Icons.bookmark,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                userController.bookingCount.toString(),
                                'Booking Aktif',
                                Icons.home,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Menu Items
                        const Text(
                          'Pengaturan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildMenuItem(
                          Icons.history,
                          'Riwayat Booking',
                          'Lihat riwayat booking kos',
                          () => _showComingSoon('Riwayat Booking'),
                        ),
                        _buildMenuItem(
                          Icons.bookmark,
                          'Kos Bookmark',
                          'Kos yang Anda bookmark',
                          () => _showComingSoon('Kos Bookmark'),
                        ),
                        _buildMenuItem(
                          Icons.payment,
                          'Metode Pembayaran',
                          'Kelola metode pembayaran',
                          () => _showComingSoon('Metode Pembayaran'),
                        ),
                        _buildMenuItem(
                          Icons.notifications,
                          'Notifikasi',
                          'Pengaturan notifikasi',
                          () => _showComingSoon('Pengaturan Notifikasi'),
                        ),
                        _buildMenuItem(
                          Icons.security,
                          'Keamanan',
                          'Ubah password dan keamanan',
                          () => _showComingSoon('Keamanan'),
                        ),
                        _buildMenuItem(
                          Icons.help,
                          'Bantuan',
                          'FAQ dan dukungan pelanggan',
                          () => _showAboutDialog(),
                        ),

                        const SizedBox(height: 32),

                        // Logout Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _showLogoutDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Keluar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildProfileField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: _isEditing,
          keyboardType: label == 'Email'
              ? TextInputType.emailAddress
              : label == 'Nomor Telepon'
              ? TextInputType.phone
              : TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label tidak boleh kosong';
            }
            if (label == 'Email' && !value.contains('@')) {
              return 'Format email tidak valid';
            }
            if (label == 'Nomor Telepon') {
              // Remove all non-digit characters for validation
              String digits = value.replaceAll(RegExp(r'[^0-9]'), '');
              if (digits.length < 10 || digits.length > 15) {
                return 'Nomor telepon harus 10-15 digit';
              }
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: _isEditing ? Colors.white : Colors.grey[100],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Theme.of(context).primaryColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature akan segera tersedia')));
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Boss Kost',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.home,
        size: 50,
        color: Theme.of(context).primaryColor,
      ),
      children: const [
        Text('Aplikasi pencarian kos terbaik untuk mahasiswa dan pekerja.'),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Berhasil keluar'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Keluar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
