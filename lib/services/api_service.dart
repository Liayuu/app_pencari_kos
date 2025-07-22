import '../models/kos.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl =
      'https://mocki.io/v1/ccbd172d-976a-4916-909f-0b6b124bf4d4';

  // Get all kos
  Future<List<Kos>> getAllKos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Kos.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load kos data');
      }
    } catch (e) {
      throw Exception('Failed to fetch kos data: $e');
    }
  }

  // Get kos by ID
  Future<Kos> getKosById(String id) async {
    try {
      // final response = await http.get(Uri.parse('$baseUrl/kos/$id'));
      // if (response.statusCode == 200) {
      //   Map<String, dynamic> data = json.decode(response.body);
      //   return Kos.fromJson(data);
      // } else {
      //   throw Exception('Kos not found');
      // }

      await Future.delayed(const Duration(milliseconds: 500));
      final kos = sampleKosData.firstWhere((k) => k.id == id);
      return kos;
    } catch (e) {
      throw Exception('Failed to fetch kos details: $e');
    }
  }

  // Search kos
  Future<List<Kos>> searchKos(Map<String, dynamic> searchParams) async {
    try {
      // final response = await http.post(
      //   Uri.parse('$baseUrl/kos/search'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode(searchParams),
      // );
      // if (response.statusCode == 200) {
      //   List<dynamic> data = json.decode(response.body);
      //   return data.map((json) => Kos.fromJson(json)).toList();
      // } else {
      //   throw Exception('Search failed');
      // }

      await Future.delayed(const Duration(seconds: 1));
      return sampleKosData; // Return filtered results in real implementation
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  // Book kos
  Future<bool> bookKos(String kosId, Map<String, dynamic> bookingData) async {
    try {
      // final response = await http.post(
      //   Uri.parse('$baseUrl/bookings'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({
      //     'kosId': kosId,
      //     ...bookingData,
      //   }),
      // );
      // return response.statusCode == 201;

      await Future.delayed(const Duration(seconds: 2));
      return true; // Simulate successful booking
    } catch (e) {
      throw Exception('Booking failed: $e');
    }
  }

  // Get user bookings
  Future<List<Map<String, dynamic>>> getUserBookings(String userId) async {
    try {
      // final response = await http.get(Uri.parse('$baseUrl/users/$userId/bookings'));
      // if (response.statusCode == 200) {
      //   return List<Map<String, dynamic>>.from(json.decode(response.body));
      // } else {
      //   throw Exception('Failed to load bookings');
      // }

      await Future.delayed(const Duration(milliseconds: 800));
      return []; // Return user bookings in real implementation
    } catch (e) {
      throw Exception('Failed to fetch bookings: $e');
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(Map<String, dynamic> profileData) async {
    try {
      // final response = await http.put(
      //   Uri.parse('$baseUrl/users/profile'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode(profileData),
      // );
      // return response.statusCode == 200;

      await Future.delayed(const Duration(seconds: 1));
      return true; // Simulate successful update
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // final response = await http.post(
      //   Uri.parse('$baseUrl/auth/login'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({
      //     'email': email,
      //     'password': password,
      //   }),
      // );
      // if (response.statusCode == 200) {
      //   return json.decode(response.body);
      // } else {
      //   throw Exception('Login failed');
      // }

      await Future.delayed(const Duration(seconds: 2));
      return {
        'token': 'sample_token',
        'user': {'id': '1', 'name': 'John Doe', 'email': email},
      };
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
