import 'package:flutter/material.dart';
import '../models/kos.dart';

class SearchController extends ChangeNotifier {
  String _searchQuery = '';
  String _selectedType = 'Semua';
  RangeValues _priceRange = const RangeValues(500000, 2000000);
  final List<String> _selectedFacilities = [];
  double _maxDistance = 5.0;
  String _sortBy = 'Relevan';

  // Search history
  final List<String> _searchHistory = [];

  // Getters
  String get searchQuery => _searchQuery;
  String get selectedType => _selectedType;
  RangeValues get priceRange => _priceRange;
  List<String> get selectedFacilities => _selectedFacilities;
  double get maxDistance => _maxDistance;
  String get sortBy => _sortBy;
  List<String> get searchHistory => _searchHistory;

  final List<String> availableTypes = ['Semua', 'Putra', 'Putri', 'Campur'];
  final List<String> availableFacilities = [
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
  final List<String> sortOptions = [
    'Relevan',
    'Terdekat',
    'Termurah',
    'Termahal',
    'Rating',
  ];

  // Update search parameters
  void updateSearchQuery(String query) {
    _searchQuery = query;
    if (query.isNotEmpty && !_searchHistory.contains(query)) {
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 10) {
        _searchHistory.removeLast();
      }
    }
    notifyListeners();
  }

  void updateSelectedType(String type) {
    _selectedType = type;
    notifyListeners();
  }

  void updatePriceRange(RangeValues range) {
    _priceRange = range;
    notifyListeners();
  }

  void updateMaxDistance(double distance) {
    _maxDistance = distance;
    notifyListeners();
  }

  void updateSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  // Facility management
  void toggleFacility(String facility) {
    if (_selectedFacilities.contains(facility)) {
      _selectedFacilities.remove(facility);
    } else {
      _selectedFacilities.add(facility);
    }
    notifyListeners();
  }

  void clearSelectedFacilities() {
    _selectedFacilities.clear();
    notifyListeners();
  }

  // Reset all filters
  void resetFilters() {
    _selectedType = 'Semua';
    _priceRange = const RangeValues(500000, 2000000);
    _selectedFacilities.clear();
    _maxDistance = 5.0;
    _sortBy = 'Relevan';
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Remove from search history
  void removeFromHistory(String query) {
    _searchHistory.remove(query);
    notifyListeners();
  }

  void clearSearchHistory() {
    _searchHistory.clear();
    notifyListeners();
  }

  // Get search parameters as Map
  Map<String, dynamic> getSearchParameters() {
    return {
      'query': _searchQuery,
      'type': _selectedType,
      'minPrice': _priceRange.start,
      'maxPrice': _priceRange.end,
      'maxDistance': _maxDistance,
      'facilities': _selectedFacilities,
      'sortBy': _sortBy,
    };
  }

  // Apply filters to kos list
  List<Kos> applyFilters(List<Kos> kosList) {
    List<Kos> filtered = kosList;

    // Search query filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((kos) {
        return kos.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            kos.address.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Type filter
    if (_selectedType != 'Semua') {
      filtered = filtered.where((kos) => kos.type == _selectedType).toList();
    }

    // Price range filter
    filtered = filtered.where((kos) {
      return kos.price >= _priceRange.start && kos.price <= _priceRange.end;
    }).toList();

    // Distance filter
    filtered = filtered.where((kos) {
      return kos.distanceToUniversity <= _maxDistance;
    }).toList();

    // Facilities filter
    if (_selectedFacilities.isNotEmpty) {
      filtered = filtered.where((kos) {
        return _selectedFacilities.every(
          (facility) => kos.facilities.contains(facility),
        );
      }).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'Terdekat':
        filtered.sort(
          (a, b) => a.distanceToUniversity.compareTo(b.distanceToUniversity),
        );
        break;
      case 'Termurah':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Termahal':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Relevan':
      default:
        // Keep original order or apply relevance sorting
        break;
    }

    return filtered;
  }
}
