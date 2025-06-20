import 'package:flutter/material.dart';
import '../models/kos.dart';
import '../widgets/kos_card.dart';
import 'search_form_screen.dart';
import 'kos_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Kos> _filteredKos = sampleKosData;
  String _selectedFilter = 'Semua';
  final List<String> _filterOptions = ['Semua', 'Putra', 'Putri', 'Campur'];
  RangeValues _priceRange = const RangeValues(500000, 2000000);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterKos();
  }

  void _filterKos() {
    setState(() {
      _filteredKos = sampleKosData.where((kos) {
        final matchesSearch =
            kos.name.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            kos.address.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );

        final matchesType =
            _selectedFilter == 'Semua' || kos.type == _selectedFilter;

        final matchesPrice =
            kos.price >= _priceRange.start && kos.price <= _priceRange.end;

        return matchesSearch && matchesType && matchesPrice;
      }).toList();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text(
                'Filter Pencarian',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tipe Kos:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: _filterOptions.map((filter) {
                      return FilterChip(
                        label: Text(filter),
                        selected: _selectedFilter == filter,
                        onSelected: (selected) {
                          setStateDialog(() {
                            _selectedFilter = filter;
                          });
                        },
                        selectedColor: const Color(0xFF1976D2).withOpacity(0.2),
                        checkmarkColor: const Color(0xFF1976D2),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Range Harga:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  RangeSlider(
                    values: _priceRange,
                    min: 500000,
                    max: 3000000,
                    divisions: 25,
                    activeColor: const Color(0xFF1976D2),
                    labels: RangeLabels(
                      'Rp ${(_priceRange.start / 1000000).toStringAsFixed(1)}jt',
                      'Rp ${(_priceRange.end / 1000000).toStringAsFixed(1)}jt',
                    ),
                    onChanged: (RangeValues values) {
                      setStateDialog(() {
                        _priceRange = values;
                      });
                    },
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
                    _filterKos();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Terapkan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cari Kos',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchFormScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF1976D2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Cari nama kos atau lokasi...',
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.filter_list,
                          color: Color(0xFF1976D2),
                        ),
                        onPressed: _showFilterDialog,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Quick filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildQuickFilterChip('Terdekat', Icons.location_on),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip('Murah', Icons.money_off),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip('Fasilitas Lengkap', Icons.star),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip('Rating Tinggi', Icons.thumb_up),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Results Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ditemukan ${_filteredKos.length} kos',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      DropdownButton<String>(
                        value: 'Relevan',
                        items: const [
                          DropdownMenuItem(
                            value: 'Relevan',
                            child: Text('Relevan'),
                          ),
                          DropdownMenuItem(
                            value: 'Terdekat',
                            child: Text('Terdekat'),
                          ),
                          DropdownMenuItem(
                            value: 'Termurah',
                            child: Text('Termurah'),
                          ),
                          DropdownMenuItem(
                            value: 'Termahal',
                            child: Text('Termahal'),
                          ),
                          DropdownMenuItem(
                            value: 'Rating',
                            child: Text('Rating Tertinggi'),
                          ),
                        ],
                        onChanged: (value) {
                          // Implement sorting logic here
                        },
                        underline: Container(),
                        style: const TextStyle(
                          color: Color(0xFF1976D2),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Kos List
                  Expanded(
                    child: _filteredKos.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 80,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada kos yang ditemukan',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Coba ubah kata kunci atau filter pencarian',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredKos.length,
                            itemBuilder: (context, index) {
                              final kos = _filteredKos[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: KosCard(
                                  kos: kos,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            KosDetailScreen(kos: kos),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilterChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
