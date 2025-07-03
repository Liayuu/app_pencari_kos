import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'kos_controller.dart';

class UserController extends ChangeNotifier {
  String _name = 'John Doe';
  String _email = 'john.doe@email.com';
  String _phone = '+62 812 3456 7890';
  String _profileImagePath = '';
  int _bookingCount = 0;
  bool _isLoggedIn = true;
  KosController? _kosController;

  // Getters
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get profileImagePath => _profileImagePath;
  int get bookingCount => _bookingCount;
  int get favoriteCount => _kosController?.favoriteCount ?? 0;
  bool get isLoggedIn => _isLoggedIn;

  // Set KosController reference
  void setKosController(KosController kosController) {
    _kosController = kosController;
    notifyListeners();
  }

  // Update profile methods
  void updateName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  void updatePhone(String newPhone) {
    _phone = newPhone;
    notifyListeners();
  }

  void updateProfileImage(String imagePath) {
    _profileImagePath = imagePath;
    notifyListeners();
  }

  // Save profile
  Future<bool> saveProfile() async {
    try {
      // Create profile data map
      final profileData = {
        'name': _name,
        'email': _email,
        'phone': _phone,
        'profileImagePath': _profileImagePath,
      };

      // Call API service to update profile
      final apiService = ApiService();
      bool success = await apiService.updateUserProfile(profileData);

      if (success) {
        // Optionally save to local storage/database here
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString('user_name', _name);
        // await prefs.setString('user_email', _email);
        // await prefs.setString('user_phone', _phone);

        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      print('Error saving profile: $e');
      return false;
    }
  }

  // Login/Logout
  Future<bool> login(String email, String password) async {
    try {
      // Simulate login API call
      await Future.delayed(const Duration(seconds: 2));
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _isLoggedIn = false;
    // Reset user data
    _name = '';
    _email = '';
    _phone = '';
    _profileImagePath = '';
    _bookingCount = 0;
    notifyListeners();
  }

  // Register
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      // Simulate register API call
      await Future.delayed(const Duration(seconds: 2));

      // In real app, call API here
      // Example:
      // final response = await ApiService.register(email, password, name, phone);

      // For now, just simulate success
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update statistics
  void incrementBookingCount() {
    _bookingCount++;
    notifyListeners();
  }

  // Load profile from local storage
  Future<void> loadProfile() async {
    try {
      // In real app, load from SharedPreferences or API
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // _name = prefs.getString('user_name') ?? 'John Doe';
      // _email = prefs.getString('user_email') ?? 'john@example.com';
      // _phone = prefs.getString('user_phone') ?? '+62812345678';

      // For now, use default values
      _name = 'John Doe';
      _email = 'john@example.com';
      _phone = '+62812345678';
      _profileImagePath = 'assets/images/profile.jpg';

      notifyListeners();
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  // Validate profile data
  bool validateProfileData() {
    return _name.isNotEmpty &&
        _email.isNotEmpty &&
        _email.contains('@') &&
        _phone.isNotEmpty;
  }
}
