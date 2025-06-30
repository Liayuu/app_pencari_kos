import 'package:flutter/material.dart';

class SearchFormScreen extends StatefulWidget {
  const SearchFormScreen({super.key});

  @override
  State<SearchFormScreen> createState() => _SearchFormScreenState();
}

class _SearchFormScreenState extends State<SearchFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _maxPriceController = TextEditingController();
  final _maxDistanceController = TextEditingController();

  String _selectedType = 'Semua';
  final List<String> _selectedFacilities = [];
  double _maxPrice = 2000000;
  double _maxDistance = 5.0;

  final List<String> _kosTypes = ['Semua', 'Putra', 'Putri', 'Campur'];
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
  ];

  @override
  void dispose() {
    _locationController.dispose();
    _maxPriceController.dispose();
    _maxDistanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian Lanjutan'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location Input
              const Text(
                'Lokasi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Masukkan lokasi yang diinginkan',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Kos Type
              const Text(
                'Tipe Kos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedType,
                    isExpanded: true,
                    items: _kosTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Max Price Slider
              const Text(
                'Harga Maksimal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  Text(
                    'Rp ${_formatPrice(_maxPrice.toInt())}/bulan',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  Slider(
                    value: _maxPrice,
                    min: 500000,
                    max: 5000000,
                    divisions: 18,
                    label: 'Rp ${_formatPrice(_maxPrice.toInt())}',
                    onChanged: (double value) {
                      setState(() {
                        _maxPrice = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Max Distance Slider
              const Text(
                'Jarak Maksimal ke Kampus',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  Text(
                    '${_maxDistance.toStringAsFixed(1)} km',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  Slider(
                    value: _maxDistance,
                    min: 0.5,
                    max: 10.0,
                    divisions: 19,
                    label: '${_maxDistance.toStringAsFixed(1)} km',
                    onChanged: (double value) {
                      setState(() {
                        _maxDistance = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Facilities
              const Text(
                'Fasilitas yang Diinginkan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: _availableFacilities.map((facility) {
                  final isSelected = _selectedFacilities.contains(facility);
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedFacilities.remove(facility);
                        } else {
                          _selectedFacilities.add(facility);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1976D2)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1976D2)
                              : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: isSelected ? Colors.white : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              facility,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),

      // Bottom Buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: safeOpacity(Colors.grey, 0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _resetForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1976D2),
                  side: const BorderSide(color: Color(0xFF1976D2)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Reset'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _performSearch();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Cari Kos'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _resetForm() {
    setState(() {
      _locationController.clear();
      _selectedType = 'Semua';
      _selectedFacilities.clear();
      _maxPrice = 2000000;
      _maxDistance = 5.0;
    });
  }

  void _performSearch() {
    // Collect search parameters
    final searchParams = {
      'location': _locationController.text,
      'type': _selectedType,
      'maxPrice': _maxPrice,
      'maxDistance': _maxDistance,
      'facilities': _selectedFacilities,
    };

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Mencari kos...'),
            ],
          ),
        );
      },
    );

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close loading dialog
      Navigator.of(
        context,
      ).pop(searchParams); // Return to previous screen with search params

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ditemukan ${_selectedFacilities.length > 2 ? '5' : '8'} kos sesuai kriteria',
          ),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
}

Color safeOpacity(Color color, double opacity) {
  if (opacity.isNaN) opacity = 1.0;
  if (opacity < 0.0) opacity = 0.0;
  if (opacity > 1.0) opacity = 1.0;
  return color.withOpacity(opacity);
}
