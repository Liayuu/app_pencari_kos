import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  bool _useGoogleMaps = false; // Disable Google Maps by default (dummy mode)

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Layanan lokasi tidak aktif. Aktifkan GPS untuk fitur yang lebih baik.',
              ),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Izin lokasi ditolak. Beberapa fitur mungkin tidak berfungsi.',
                ),
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Izin lokasi ditolak permanen. Buka Settings untuk mengaktifkan.',
              ),
              duration: Duration(seconds: 4),
            ),
          );
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lokasi berhasil ditemukan'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error mendapatkan lokasi: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
        // Use default location as fallback
        setState(() {
          _currentPosition = Position(
            latitude: -6.200000,
            longitude: 106.816666,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speed: 0,
            speedAccuracy: 0,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Peta Kos Terdekat'),
            if (_currentPosition != null)
              Text(
                'Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}, Lng: ${_currentPosition!.longitude.toStringAsFixed(4)}',
                style: const TextStyle(fontSize: 10, color: Colors.white70),
              ),
          ],
        ),
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
      body: Stack(
        children: [
          _useGoogleMaps ? _buildGoogleMapsView() : _buildFallbackMapView(),
          if (_useGoogleMaps && _currentPosition != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'Jika peta tidak tampil, pastikan API Key Google Maps sudah dikonfigurasi dengan benar.\nLihat file GOOGLE_MAPS_SETUP.md untuk panduan.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
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

  Widget _buildGoogleMapsView() {
    if (_currentPosition == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Mendapatkan lokasi...'),
            SizedBox(height: 8),
            Text(
              'Pastikan GPS aktif dan berikan izin lokasi',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        zoom: 15.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        // Map controller ready
        print('Google Maps controller initialized');
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: _buildMarkers(),
      onTap: (LatLng position) {
        setState(() {
          _selectedKos = null;
        });
      },
      // Add map style options
      mapType: MapType.normal,
      compassEnabled: true,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: true,
      zoomControlsEnabled: false, // Use custom zoom controls
      zoomGesturesEnabled: true,
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
              enabled: false, // Disable search functionality
              decoration: const InputDecoration(
                hintText: 'Pencarian dinonaktifkan (mode demo)',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onSubmitted: (value) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Pencarian dinonaktifkan')));
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

  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {};

    // Add current location marker
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: const InfoWindow(title: 'Lokasi Saya'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Add kos markers (dummy data for now)
    final List<Map<String, dynamic>> dummyKos = [
      {
        'id': '1',
        'name': 'Kos Melati',
        'lat': _currentPosition?.latitude ?? -6.200000 + 0.001,
        'lng': _currentPosition?.longitude ?? 106.816666 + 0.001,
      },
      {
        'id': '2',
        'name': 'Kos Mawar',
        'lat': _currentPosition?.latitude ?? -6.200000 - 0.001,
        'lng': _currentPosition?.longitude ?? 106.816666 - 0.001,
      },
      {
        'id': '3',
        'name': 'Kos Sakura',
        'lat': _currentPosition?.latitude ?? -6.200000 + 0.002,
        'lng': _currentPosition?.longitude ?? 106.816666 - 0.002,
      },
    ];

    for (var kos in dummyKos) {
      markers.add(
        Marker(
          markerId: MarkerId(kos['id']),
          position: LatLng(kos['lat'], kos['lng']),
          infoWindow: InfoWindow(
            title: kos['name'],
            snippet: 'Tap untuk detail',
          ),
          onTap: () {
            // Handle marker tap
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tapped on ${kos['name']}'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      );
    }

    return markers;
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
