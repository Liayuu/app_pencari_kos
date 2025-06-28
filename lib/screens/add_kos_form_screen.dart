import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../controllers/kos_controller.dart';
import '../models/kos.dart';

class AddKosFormScreen extends StatefulWidget {
  const AddKosFormScreen({super.key});

  @override
  State<AddKosFormScreen> createState() => _AddKosFormScreenState();
}

class _AddKosFormScreenState extends State<AddKosFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  bool _useCurrentLocation = false;

  final List<String> _kosTypes = ['Putra', 'Putri', 'Campur'];
  final List<String> _availableFacilities = [
    'WiFi',
    'AC',
    'Kamar Mandi Dalam',
    'Kamar Mandi Luar',
    'Parkir Motor',
    'Parkir Mobil',
    'Dapur Bersama',
    'Laundry',
    'Security 24 Jam',
    'Gym',
    'Kolam Renang',
    'Ruang Tamu',
    'CCTV',
    'Kulkas',
    'Water Heater',
  ];

  // Add image picker functionality
  final List<String> _selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kos Baru'),
        actions: [
          IconButton(icon: const Icon(Icons.help), onPressed: _showHelpDialog),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.home_work, size: 48, color: Colors.blue),
                      const SizedBox(height: 8),
                      const Text(
                        'Informasi Kos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lengkapi data kos dengan detail untuk menarik penyewa',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Basic Information
              _buildSectionTitle('Informasi Dasar'),
              _buildBasicInfoSection(),

              const SizedBox(height: 24),

              // Location Information
              _buildSectionTitle('Informasi Lokasi'),
              _buildLocationSection(),

              const SizedBox(height: 24),

              // Price & Type
              _buildSectionTitle('Harga & Tipe'),
              _buildPriceTypeSection(),

              const SizedBox(height: 24),

              // Facilities
              _buildSectionTitle('Fasilitas'),
              _buildFacilitiesSection(),

              const SizedBox(height: 24),

              // Description
              _buildSectionTitle('Deskripsi'),
              _buildDescriptionSection(),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Tambah Kos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
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

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'name',
              decoration: const InputDecoration(
                labelText: 'Nama Kos *',
                hintText: 'Contoh: Kos Melati Indah',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: 'Nama kos harus diisi',
                ),
                FormBuilderValidators.minLength(
                  3,
                  errorText: 'Nama kos minimal 3 karakter',
                ),
                FormBuilderValidators.maxLength(
                  50,
                  errorText: 'Nama kos maksimal 50 karakter',
                ),
              ]),
            ),

            const SizedBox(height: 16),

            FormBuilderTextField(
              name: 'address',
              decoration: const InputDecoration(
                labelText: 'Alamat Lengkap *',
                hintText: 'Jl. Sudirman No. 123, Kelurahan, Kecamatan, Kota',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'Alamat harus diisi'),
                FormBuilderValidators.minLength(
                  10,
                  errorText: 'Alamat minimal 10 karakter',
                ),
              ]),
            ),

            const SizedBox(height: 16),

            // Image upload section
            GestureDetector(
              onTap: _pickImages,
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Tambah Foto Kos',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Text(
                      '(Maksimal 5 foto)',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FormBuilderCheckbox(
              name: 'useCurrentLocation',
              title: const Text('Gunakan lokasi saat ini'),
              initialValue: _useCurrentLocation,
              onChanged: (value) {
                setState(() {
                  _useCurrentLocation = value ?? false;
                });
                if (_useCurrentLocation) {
                  _getCurrentLocation();
                }
              },
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: 'latitude',
                    decoration: const InputDecoration(
                      labelText: 'Latitude *',
                      hintText: '-6.200000',
                      prefixIcon: Icon(Icons.my_location),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: 'Latitude harus diisi',
                      ),
                      FormBuilderValidators.numeric(
                        errorText: 'Format latitude tidak valid',
                      ),
                      FormBuilderValidators.min(
                        -90,
                        errorText: 'Latitude minimal -90',
                      ),
                      FormBuilderValidators.max(
                        90,
                        errorText: 'Latitude maksimal 90',
                      ),
                    ]),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FormBuilderTextField(
                    name: 'longitude',
                    decoration: const InputDecoration(
                      labelText: 'Longitude *',
                      hintText: '106.816666',
                      prefixIcon: Icon(Icons.place),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: 'Longitude harus diisi',
                      ),
                      FormBuilderValidators.numeric(
                        errorText: 'Format longitude tidak valid',
                      ),
                      FormBuilderValidators.min(
                        -180,
                        errorText: 'Longitude minimal -180',
                      ),
                      FormBuilderValidators.max(
                        180,
                        errorText: 'Longitude maksimal 180',
                      ),
                    ]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            FormBuilderSlider(
              name: 'distanceToUniversity',
              decoration: const InputDecoration(
                labelText: 'Jarak ke Universitas Terdekat (km)',
                border: OutlineInputBorder(),
              ),
              min: 0.1,
              max: 20.0,
              divisions: 199,
              initialValue: 2.0,
              displayValues: DisplayValues.current,
              valueTransformer: (value) => value?.toDouble(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceTypeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'price',
              decoration: const InputDecoration(
                labelText: 'Harga per Bulan (Rp) *',
                hintText: '1500000',
                prefixIcon: Icon(Icons.monetization_on),
                border: OutlineInputBorder(),
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'Harga harus diisi'),
                FormBuilderValidators.numeric(
                  errorText: 'Harga harus berupa angka',
                ),
                FormBuilderValidators.min(
                  100000,
                  errorText: 'Harga minimal Rp 100.000',
                ),
                FormBuilderValidators.max(
                  50000000,
                  errorText: 'Harga maksimal Rp 50.000.000',
                ),
              ]),
              valueTransformer: (value) => int.tryParse(value ?? '0'),
            ),

            const SizedBox(height: 16),

            FormBuilderDropdown<String>(
              name: 'type',
              decoration: const InputDecoration(
                labelText: 'Tipe Kos *',
                prefixIcon: Icon(Icons.people),
                border: OutlineInputBorder(),
              ),
              items: _kosTypes
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
              validator: FormBuilderValidators.required(
                errorText: 'Tipe kos harus dipilih',
              ),
            ),

            const SizedBox(height: 16),

            FormBuilderRangeSlider(
              name: 'availableRooms',
              decoration: const InputDecoration(
                labelText: 'Jumlah Kamar (Tersedia - Total)',
                border: OutlineInputBorder(),
              ),
              min: 1,
              max: 50,
              divisions: 49,
              initialValue: const RangeValues(5, 10),
              displayValues: DisplayValues.current,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilitiesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih fasilitas yang tersedia:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            FormBuilderCheckboxGroup<String>(
              name: 'facilities',
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              options: _availableFacilities
                  .map(
                    (facility) => FormBuilderFieldOption(
                      value: facility,
                      child: Text(facility),
                    ),
                  )
                  .toList(),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.minLength(
                  1,
                  errorText: 'Pilih minimal 1 fasilitas',
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'description',
              decoration: const InputDecoration(
                labelText: 'Deskripsi Kos *',
                hintText:
                    'Deskripsikan kos Anda dengan detail. Ceritakan keunggulan, aturan, dan hal menarik lainnya...',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              maxLength: 1000,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: 'Deskripsi harus diisi',
                ),
                FormBuilderValidators.minLength(
                  50,
                  errorText: 'Deskripsi minimal 50 karakter',
                ),
                FormBuilderValidators.maxLength(
                  1000,
                  errorText: 'Deskripsi maksimal 1000 karakter',
                ),
              ]),
            ),

            const SizedBox(height: 16),

            FormBuilderSwitch(
              name: 'isAvailable',
              title: const Text('Kos tersedia untuk disewa'),
              initialValue: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: 16),

            FormBuilderDateTimePicker(
              name: 'availableFrom',
              decoration: const InputDecoration(
                labelText: 'Tersedia Mulai Tanggal',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              inputType: InputType.date,
              initialValue: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            ),

            const SizedBox(height: 16),

            // Image Picker
            _buildImagePickerSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Foto Kos (Opsional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Tambahkan foto kos Anda untuk menarik lebih banyak penyewa.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedImages
                  .map(
                    (image) => Chip(
                      label: Text(image),
                      onDeleted: () {
                        setState(() {
                          _selectedImages.remove(image);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Pilih Gambar'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImages() async {
    // For now, just show a placeholder dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload Foto'),
          content: const Text(
            'Fitur upload foto akan segera tersedia. Anda dapat menambahkan foto kos untuk menarik lebih banyak penyewa.',
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

  void _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }

      Position position = await Geolocator.getCurrentPosition();

      if (mounted) {
        _formKey.currentState?.fields['latitude']?.didChange(
          position.latitude.toString(),
        );
        _formKey.currentState?.fields['longitude']?.didChange(
          position.longitude.toString(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lokasi berhasil didapatkan!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mendapatkan lokasi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final formData = _formKey.currentState!.value;

        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        // Add to local controller
        if (!mounted) return;
        final kosController = Provider.of<KosController>(
          context,
          listen: false,
        );

        final newKos = Kos(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: formData['name'] ?? '',
          address: formData['address'] ?? '',
          latitude: double.tryParse(formData['latitude'] ?? '0') ?? 0.0,
          longitude: double.tryParse(formData['longitude'] ?? '0') ?? 0.0,
          price: int.tryParse(formData['price']?.toString() ?? '0') ?? 0,
          description: formData['description'] ?? '',
          facilities: List<String>.from(formData['facilities'] ?? []),
          images: [], // Empty for now, can be added later
          rating: 0.0,
          distanceToUniversity: formData['distanceToUniversity'] ?? 2.0,
          type: formData['type'] ?? 'Campur',
          isAvailable: formData['isAvailable'] ?? true,
        );

        kosController.addKos(newKos);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kos berhasil ditambahkan!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menambahkan kos: $e'),
              backgroundColor: Colors.red,
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua field yang diperlukan'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bantuan'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tips mengisi form:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• Gunakan nama yang menarik dan mudah diingat'),
                Text('• Isi alamat dengan lengkap untuk memudahkan pencarian'),
                Text('• Aktifkan GPS untuk mendapatkan koordinat otomatis'),
                Text('• Pilih harga yang kompetitif dengan area sekitar'),
                Text(
                  '• Semakin lengkap fasilitas, semakin menarik untuk penyewa',
                ),
                Text('• Deskripsi yang detail akan meningkatkan kepercayaan'),
              ],
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
}
