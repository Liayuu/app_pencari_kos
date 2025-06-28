class Kos {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int price;
  final String description;
  final List<String> facilities;
  final List<String> images;
  final double rating;
  final double distanceToUniversity;
  final String type; // Putra/Putri/Campur
  final bool isAvailable;

  Kos({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.price,
    required this.description,
    required this.facilities,
    required this.images,
    required this.rating,
    required this.distanceToUniversity,
    required this.type,
    required this.isAvailable,
  });

  factory Kos.fromJson(Map<String, dynamic> json) {
    return Kos(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      price: json['price'] ?? 0,
      description: json['description'] ?? '',
      facilities: json['facilities'] is String
          ? (json['facilities'] as String).split(',')
          : List<String>.from(json['facilities'] ?? []),
      images: json['images'] is String
          ? (json['images'] as String).split(',')
          : List<String>.from(json['images'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      distanceToUniversity: (json['distanceToUniversity'] ?? 0.0).toDouble(),
      type: json['type'] ?? '',
      isAvailable: json['isAvailable'] == 1 || json['isAvailable'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'price': price,
      'description': description,
      'facilities': facilities.join(','),
      'images': images.join(','),
      'rating': rating,
      'distanceToUniversity': distanceToUniversity,
      'type': type,
      'isAvailable': isAvailable ? 1 : 0,
    };
  }
}

// Sample data untuk testing
List<Kos> sampleKosData = [
  Kos(
    id: '1',
    name: 'Kos Melati',
    address: 'Jl. Sudirman No. 123, Jakarta Pusat',
    latitude: -6.2088,
    longitude: 106.8456,
    price: 1500000,
    description:
        'Kos nyaman dengan fasilitas lengkap, dekat kampus dan pusat perbelanjaan.',
    facilities: [
      'WiFi',
      'AC',
      'Kamar Mandi Dalam',
      'Parkir Motor',
      'Dapur Bersama',
    ],
    images: ['assets/images/kos1.jpg', 'assets/images/kos1_2.jpg'],
    rating: 4.5,
    distanceToUniversity: 0.8,
    type: 'Putri',
    isAvailable: true,
  ),
  Kos(
    id: '2',
    name: 'Kos Mawar',
    address: 'Jl. Thamrin No. 456, Jakarta Pusat',
    latitude: -6.1944,
    longitude: 106.8229,
    price: 1200000,
    description:
        'Kos strategis di pusat kota dengan akses mudah ke berbagai tempat.',
    facilities: ['WiFi', 'Kamar Mandi Dalam', 'Parkir Motor', 'Laundry'],
    images: ['assets/images/kos2.jpg'],
    rating: 4.2,
    distanceToUniversity: 1.2,
    type: 'Putra',
    isAvailable: true,
  ),
  Kos(
    id: '3',
    name: 'Kos Anggrek',
    address: 'Jl. Gatot Subroto No. 789, Jakarta Selatan',
    latitude: -6.2297,
    longitude: 106.8252,
    price: 1800000,
    description: 'Kos mewah dengan fasilitas premium dan keamanan 24 jam.',
    facilities: [
      'WiFi',
      'AC',
      'Kamar Mandi Dalam',
      'Parkir Motor',
      'Parkir Mobil',
      'Security 24 Jam',
      'Gym',
    ],
    images: ['assets/images/kos3.jpg'],
    rating: 4.8,
    distanceToUniversity: 0.5,
    type: 'Campur',
    isAvailable: true,
  ),
  Kos(
    id: '4',
    name: 'Kos Seruni',
    address: 'Jl. Casablanca No. 321, Jakarta Selatan',
    latitude: -6.2441,
    longitude: 106.8415,
    price: 1000000,
    description: 'Kos budget friendly dengan fasilitas standar namun nyaman.',
    facilities: ['WiFi', 'Kamar Mandi Luar', 'Parkir Motor', 'Dapur Bersama'],
    images: ['assets/images/kos4.jpg'],
    rating: 4.0,
    distanceToUniversity: 2.1,
    type: 'Putri',
    isAvailable: false,
  ),
];
