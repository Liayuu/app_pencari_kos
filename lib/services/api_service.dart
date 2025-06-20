import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kos.dart';

class ApiService {
  static const String baseUrl = 'https://api.bosskost.com/v1';

  // Simulate API call for searching kos
  static Future<List<Kos>> searchKos({
    String? location,
    String? type,
    double? maxPrice,
    double? maxDistance,
    List<String>? facilities,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // In real implementation, make HTTP request here
      // final response = await http.get(
      //   Uri.parse('$baseUrl/kos/search'),
      //   headers: {'Content-Type': 'application/json'},
      // );

      // For now, return sample data with filtering
      List<Kos> results = List.from(sampleKosData);

      // Apply filters
      if (type != null && type != 'Semua') {
        results = results.where((kos) => kos.type == type).toList();
      }

      if (maxPrice != null) {
        results = results.where((kos) => kos.price <= maxPrice).toList();
      }

      if (maxDistance != null) {
        results = results
            .where((kos) => kos.distanceToUniversity <= maxDistance)
            .toList();
      }

      if (facilities != null && facilities.isNotEmpty) {
        results = results.where((kos) {
          return facilities.every(
            (facility) => kos.facilities.contains(facility),
          );
        }).toList();
      }

      if (location != null && location.isNotEmpty) {
        results = results.where((kos) {
          return kos.address.toLowerCase().contains(location.toLowerCase()) ||
              kos.name.toLowerCase().contains(location.toLowerCase());
        }).toList();
      }

      return results;
    } catch (e) {
      throw Exception('Failed to search kos: $e');
    }
  }

  // Get kos by ID
  static Future<Kos?> getKosById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // In real implementation:
      // final response = await http.get(Uri.parse('$baseUrl/kos/$id'));

      return sampleKosData.firstWhere(
        (kos) => kos.id == id,
        orElse: () => throw Exception('Kos not found'),
      );
    } catch (e) {
      throw Exception('Failed to get kos: $e');
    }
  }

  // Get nearby kos based on location
  static Future<List<Kos>> getNearbyKos(
    double latitude,
    double longitude, {
    double radius = 5.0,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // In real implementation:
      // final response = await http.post(
      //   Uri.parse('$baseUrl/kos/nearby'),
      //   body: jsonEncode({
      //     'latitude': latitude,
      //     'longitude': longitude,
      //     'radius': radius,
      //   }),
      //   headers: {'Content-Type': 'application/json'},
      // );

      // For simulation, return all sample data
      return sampleKosData;
    } catch (e) {
      throw Exception('Failed to get nearby kos: $e');
    }
  }

  // Book a kos
  static Future<bool> bookKos(
    String kosId,
    Map<String, dynamic> bookingData,
  ) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      // In real implementation:
      // final response = await http.post(
      //   Uri.parse('$baseUrl/bookings'),
      //   body: jsonEncode({
      //     'kosId': kosId,
      //     ...bookingData,
      //   }),
      //   headers: {'Content-Type': 'application/json'},
      // );

      // Simulate successful booking
      return true;
    } catch (e) {
      throw Exception('Failed to book kos: $e');
    }
  }

  // Get user's bookings
  static Future<List<Map<String, dynamic>>> getUserBookings(
    String userId,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));

      // Return sample booking data
      return [
        {
          'id': '1',
          'kosId': '1',
          'kosName': 'Kos Melati',
          'status': 'confirmed',
          'bookingDate': DateTime.now().subtract(const Duration(days: 5)),
          'startDate': DateTime.now().add(const Duration(days: 25)),
          'duration': 12, // months
        },
      ];
    } catch (e) {
      throw Exception('Failed to get bookings: $e');
    }
  }

  // Send message to kos owner
  static Future<bool> sendMessage(String kosId, String message) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      // In real implementation:
      // final response = await http.post(
      //   Uri.parse('$baseUrl/messages'),
      //   body: jsonEncode({
      //     'kosId': kosId,
      //     'message': message,
      //   }),
      //   headers: {'Content-Type': 'application/json'},
      // );

      return true;
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
