import 'package:flutter/material.dart';
import '../models/kos.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';

class KosController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Kos> _allKos = [];
  List<Kos> _filteredKos = [];
  List<Kos> _favoriteKos = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<Kos> get allKos => _allKos;
  List<Kos> get filteredKos => _filteredKos;
  List<Kos> get favoriteKos => _favoriteKos;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Initialize data
  void initializeData() {
    _allKos = sampleKosData;
    _filteredKos = _allKos;
    loadFavorites(); // Load saved favorites from database
    notifyListeners();
  }

  // Search and filter methods
  void searchKos(String query) {
    if (query.isEmpty) {
      _filteredKos = _allKos;
    } else {
      _filteredKos = _allKos.where((kos) {
        return kos.name.toLowerCase().contains(query.toLowerCase()) ||
            kos.address.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void filterByType(String type) {
    if (type == 'Semua') {
      _filteredKos = _allKos;
    } else {
      _filteredKos = _allKos.where((kos) => kos.type == type).toList();
    }
    notifyListeners();
  }

  void filterByPriceRange(double minPrice, double maxPrice) {
    _filteredKos = _allKos.where((kos) {
      return kos.price >= minPrice && kos.price <= maxPrice;
    }).toList();
    notifyListeners();
  }

  void filterByFacilities(List<String> requiredFacilities) {
    if (requiredFacilities.isEmpty) {
      _filteredKos = _allKos;
    } else {
      _filteredKos = _allKos.where((kos) {
        return requiredFacilities.every(
          (facility) => kos.facilities.contains(facility),
        );
      }).toList();
    }
    notifyListeners();
  }

  void sortKos(String sortType) {
    switch (sortType) {
      case 'Terdekat':
        _filteredKos.sort(
          (a, b) => a.distanceToUniversity.compareTo(b.distanceToUniversity),
        );
        break;
      case 'Termurah':
        _filteredKos.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Termahal':
        _filteredKos.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        _filteredKos.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    notifyListeners();
  }

  // Favorite management
  void toggleFavorite(Kos kos) async {
    try {
      if (_favoriteKos.any((k) => k.id == kos.id)) {
        _favoriteKos.removeWhere((k) => k.id == kos.id);
        // Notify immediately for UI update
        notifyListeners();
        // Remove from SQLite (background)
        await _databaseHelper.removeFavorite(kos.id);
      } else {
        _favoriteKos.add(kos);
        // Notify immediately for UI update
        notifyListeners();
        // Add to SQLite (background)
        await _databaseHelper.addFavorite(kos.id);
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      notifyListeners();
    }
  }

  // Load favorites from SQLite
  Future<void> loadFavorites() async {
    try {
      final favoriteIds = await _databaseHelper.getFavorites();
      _favoriteKos = _allKos
          .where((kos) => favoriteIds.contains(kos.id))
          .toList();
      
      notifyListeners();
      debugPrint('Loaded ${_favoriteKos.length} favorites');
    } catch (e) {
      _errorMessage = 'Error loading favorites: $e';
      debugPrint('Error loading favorites: $e');
    }
  }

  bool isFavorite(Kos kos) {
    return _favoriteKos.any((k) => k.id == kos.id);
  }

  // Load from API
  Future<void> loadKosFromApi() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _allKos = await _apiService.getAllKos();
      _filteredKos = _allKos;
    } catch (e) {
      _errorMessage = 'Failed to load kos data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get kos by ID
  Kos? getKosById(String id) {
    try {
      return _allKos.firstWhere((kos) => kos.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get nearby kos
  List<Kos> getNearbyKos(double userLat, double userLng, double radiusKm) {
    return _allKos.where((kos) {
      // Simple distance calculation (for demo purposes)
      double distance = _calculateDistance(
        userLat,
        userLng,
        kos.latitude,
        kos.longitude,
      );
      return distance <= radiusKm;
    }).toList();
  }

  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    // Simple Euclidean distance for demo
    // In real app, use Haversine formula
    return ((lat1 - lat2).abs() + (lng1 - lng2).abs()) *
        111.0; // rough km conversion
  }

  // Reset filters
  void resetFilters() {
    _filteredKos = _allKos;
    notifyListeners();
  }

  // Add new kos
  void addKos(Kos kos) {
    _allKos.add(kos);
    _filteredKos = _allKos; // Reset filter to show new kos
    notifyListeners();
  }

  // Update existing kos
  void updateKos(Kos updatedKos) {
    final index = _allKos.indexWhere((kos) => kos.id == updatedKos.id);
    if (index != -1) {
      _allKos[index] = updatedKos;
      // Update filtered list as well
      final filteredIndex = _filteredKos.indexWhere(
        (kos) => kos.id == updatedKos.id,
      );
      if (filteredIndex != -1) {
        _filteredKos[filteredIndex] = updatedKos;
      }
      notifyListeners();
    }
  }

  // Delete kos
  void deleteKos(String kosId) {
    _allKos.removeWhere((kos) => kos.id == kosId);
    _filteredKos.removeWhere((kos) => kos.id == kosId);
    _favoriteKos.removeWhere((kos) => kos.id == kosId);
    notifyListeners();
  }
}
