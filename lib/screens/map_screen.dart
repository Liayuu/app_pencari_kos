import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../models/kos.dart';
import '../controllers/kos_controller.dart';
import 'kos_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Kos? _selectedKos;
  Position? _currentPosition;
  bool _useGoogleMaps = false; // Toggle this to enable Google Maps

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    } catch (e) {
      // Error getting location
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Kos Terdekat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              _getCurrentLocation();
            },
          ),
          IconButton(
            icon: Icon(_useGoogleMaps ? Icons.map : Icons.view_module),
            onPressed: () {
              setState(() {
                _useGoogleMaps = !_useGoogleMaps;
              });
            },
          ),
        ],
      ),
      body: _useGoogleMaps ? _buildGoogleMapsView() : _buildFallbackMapView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFilterDialog();
        },
        child: const Icon(Icons.filter_list),
      ),
    );
  }

  Widget _buildGoogleMapsView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Google Maps',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Memerlukan API Key untuk aktivasi'),
          SizedBox(height: 16),
          Text(
            'Untuk mengaktifkan Google Maps:\n'
            '1. Dapatkan API Key dari Google Cloud Console\n'
            '2. Tambahkan ke android/app/src/main/AndroidManifest.xml\n'
            '3. Set _useGoogleMaps = true',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackMapView() {
    return Stack(
      children: [
        // Mock Map Background
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue[100]!, Colors.green[100]!],
            ),
          ),
          child: CustomPaint(
            painter: MapGridPainter(),
            child: Stack(
              children: [
                // Current Location
                if (_currentPosition != null)
                  const Positioned(
                    top: 200,
                    left: 200,
                    child: Icon(Icons.my_location, color: Colors.red, size: 30),
                  ),

                // Kos Markers
                ..._buildKosMarkers(),
              ],
            ),
          ),
        ),

        // Search bar on top
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari lokasi...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
              onSubmitted: (value) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Mencari: $value')));
              },
            ),
          ),
        ),

        // Selected kos info card
        if (_selectedKos != null)
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: _buildSelectedKosCard(_selectedKos!),
          ),

        // Legend
        Positioned(
          top: 80,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Keterangan:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 8),
                _buildLegendItem(Icons.location_on, Colors.green, 'Tersedia'),
                _buildLegendItem(Icons.location_on, Colors.red, 'Penuh'),
                _buildLegendItem(Icons.my_location, Colors.blue, 'Lokasi Anda'),
              ],
            ),
          ),
        ),

        // Map Type Toggle
        Positioned(
          bottom: 100,
          right: 16,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _useGoogleMaps ? Icons.view_module : Icons.map,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _useGoogleMaps = !_useGoogleMaps;
                    });
                  },
                ),
                Text(
                  _useGoogleMaps ? 'List' : 'Maps',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildKosMarkers() {
    final kosController = Provider.of<KosController>(context, listen: false);
    final nearbyKos = kosController.allKos;

    return nearbyKos.asMap().entries.map((entry) {
      int index = entry.key;
      Kos kos = entry.value;

      // Position markers in a scattered pattern
      double left = 50.0 + (index * 60) % 250;
      double top = 100.0 + (index * 80) % 300;

      return Positioned(
        left: left,
        top: top,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedKos = kos;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: kos.isAvailable ? Colors.green : Colors.red,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.home, color: Colors.white, size: 20),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildSelectedKosCard(Kos kos) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: Colors.grey[300]),
                child: kos.images.isNotEmpty
                    ? Image.asset(
                        kos.images[0],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.home, size: 40);
                        },
                      )
                    : const Icon(Icons.home, size: 40),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    kos.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kos.address,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Rp ${kos.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}/bulan',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          Text(
                            kos.rating.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KosDetailScreen(kos: kos),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Kos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: const Text('Kamar Tersedia'),
                value: true,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: const Text('Harga < 1 Juta'),
                value: false,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: const Text('WiFi'),
                value: true,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: const Text('AC'),
                value: false,
                onChanged: (value) {},
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
                // Apply filters
              },
              child: const Text('Terapkan'),
            ),
          ],
        );
      },
    );
  }
}

// Custom painter for grid pattern
class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    // Draw grid lines
    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += 50) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Draw roads
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 8;

    // Horizontal roads
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width, size.height * 0.7),
      roadPaint,
    );

    // Vertical roads
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.7, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
