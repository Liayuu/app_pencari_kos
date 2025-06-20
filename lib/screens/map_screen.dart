import 'package:flutter/material.dart';
import 'dart:async';
import '../models/kos.dart';
import 'kos_detail_screen.dart';

// For now we'll create a simple map placeholder since Google Maps requires API key setup
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<Kos> _nearbyKos = sampleKosData;
  Kos? _selectedKos;

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
        ],
      ),
      body: Stack(
        children: [
          // Map Placeholder - In real implementation, use GoogleMaps widget
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[200],
            child: Stack(
              children: [
                // Map background pattern
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue[100]!, Colors.green[100]!],
                    ),
                  ),
                ),
                // Mock map grid
                CustomPaint(size: Size.infinite, painter: MapGridPainter()),
                // Kos markers
                ..._buildKosMarkers(),
                // Current location marker
                const Positioned(
                  top: 200,
                  left: 200,
                  child: Icon(Icons.my_location, color: Colors.blue, size: 30),
                ),
              ],
            ),
          ),

          // Search bar on top of map
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
                  _searchLocation(value);
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
                  _buildLegendItem(
                    Icons.my_location,
                    Colors.blue,
                    'Lokasi Anda',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFilterDialog();
        },
        child: const Icon(Icons.filter_list),
      ),
    );
  }

  List<Widget> _buildKosMarkers() {
    return _nearbyKos.asMap().entries.map((entry) {
      final index = entry.key;
      final kos = entry.value;

      // Calculate position based on index (mock positioning)
      final double left = 50.0 + (index * 80);
      final double top = 150.0 + (index % 3 * 100);

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
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.location_on,
              color: kos.isAvailable ? Colors.green : Colors.red,
              size: 30,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildSelectedKosCard(Kos kos) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    kos.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _selectedKos = null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              kos.address,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, size: 16, color: Colors.orange),
                const SizedBox(width: 4),
                Text('${kos.rating}'),
                const SizedBox(width: 16),
                Text(
                  'Rp ${_formatPrice(kos.price)}/bulan',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KosDetailScreen(kos: kos),
                        ),
                      );
                    },
                    child: const Text('Lihat Detail'),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    _navigateToKos(kos);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1976D2),
                    side: const BorderSide(color: Color(0xFF1976D2)),
                  ),
                  child: const Text('Rute'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _getCurrentLocation() {
    // Implement get current location
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mengambil lokasi saat ini...')),
    );
  }

  void _searchLocation(String query) {
    // Implement location search
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Mencari: $query')));
  }

  void _navigateToKos(Kos kos) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Navigasi'),
          content: Text('Buka navigasi ke ${kos.name}?'),
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
                // Implement navigation to Google Maps or other map app
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Membuka navigasi ke ${kos.name}'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Buka'),
            ),
          ],
        );
      },
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
                title: const Text('Kos Tersedia'),
                value: true,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: const Text('Rating > 4.0'),
                value: false,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: const Text('Harga < 1.5 Juta'),
                value: false,
                onChanged: (value) {},
              ),
            ],
          ),
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
                  const SnackBar(content: Text('Filter diterapkan')),
                );
              },
              child: const Text('Terapkan'),
            ),
          ],
        );
      },
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    // Draw grid lines
    for (int i = 0; i < size.width; i += 50) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }

    for (int i = 0; i < size.height; i += 50) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
