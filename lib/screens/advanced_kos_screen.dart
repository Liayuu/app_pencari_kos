import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/kos_controller.dart';
import '../controllers/search_controller.dart' as search_ctrl;
import '../models/kos.dart';
import 'kos_detail_screen.dart';

class AdvancedKosScreen extends StatefulWidget {
  const AdvancedKosScreen({super.key});

  @override
  State<AdvancedKosScreen> createState() => _AdvancedKosScreenState();
}

class _AdvancedKosScreenState extends State<AdvancedKosScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isGridView = true;
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Kos Explorer'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Semua'),
            Tab(icon: Icon(Icons.male), text: 'Putra'),
            Tab(icon: Icon(Icons.female), text: 'Putri'),
            Tab(icon: Icon(Icons.group), text: 'Campur'),
          ],
        ),
        actions: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: IconButton(
                  icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                  onPressed: () {
                    setState(() {
                      _isGridView = !_isGridView;
                    });
                    _animationController.forward().then((_) {
                      _animationController.reverse();
                    });
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildKosView('Semua'),
          _buildKosView('Putra'),
          _buildKosView('Putri'),
          _buildKosView('Campur'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddKosDialog,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kos'),
      ),
    );
  }

  Widget _buildKosView(String category) {
    return Consumer2<KosController, search_ctrl.SearchController>(
      builder: (context, kosController, searchController, child) {
        final kosList = kosController.filteredKos
            .where((kos) => category == 'Semua' || kos.type == category)
            .toList();

        if (kosList.isEmpty) {
          return _buildEmptyState(category);
        }

        return Column(
          children: [
            // Filter Chips with Flexible
            Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      [
                        'Terdekat',
                        'Termurah',
                        'Terpopuler',
                        'Rating Tinggi',
                        'Fasilitas Lengkap',
                      ].map((filter) {
                        final isSelected = _selectedCategory == filter;
                        return Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              child: FilterChip(
                                label: Text(filter),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategory = selected
                                        ? filter
                                        : 'Semua';
                                  });
                                },
                                selectedColor: Theme.of(context).primaryColor,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),

            // Expandable Search Options
            ExpansionTile(
              title: const Text(
                'Opsi Pencarian Lanjutan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.tune),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Price Range Slider
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Rentang Harga',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      RangeSlider(
                        values: const RangeValues(500000, 2000000),
                        min: 200000,
                        max: 5000000,
                        divisions: 20,
                        labels: const RangeLabels('500K', '2M'),
                        onChanged: (values) {
                          // Update filter
                        },
                      ),
                      const SizedBox(height: 16),

                      // Distance Range
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Jarak Maksimal (km)',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Slider(
                        value: 5.0,
                        min: 1.0,
                        max: 20.0,
                        divisions: 19,
                        label: '5 km',
                        onChanged: (value) {
                          // Update filter
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Kos List/Grid
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isGridView
                    ? _buildGridView(kosList)
                    : _buildListView(kosList),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGridView(List<Kos> kosList) {
    return GridView.builder(
      key: const ValueKey('grid'),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: kosList.length,
      itemBuilder: (context, index) {
        final kos = kosList[index];
        return _buildKosGridCard(kos);
      },
    );
  }

  Widget _buildListView(List<Kos> kosList) {
    return ListView.builder(
      key: const ValueKey('list'),
      padding: const EdgeInsets.all(16),
      itemCount: kosList.length,
      itemBuilder: (context, index) {
        final kos = kosList[index];
        return _buildKosListCard(kos);
      },
    );
  }

  Widget _buildKosGridCard(Kos kos) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToDetail(kos),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Stack overlay
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: kos.images.isNotEmpty
                          ? DecorationImage(
                              image: AssetImage(kos.images.first),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: Colors.grey[300],
                    ),
                    child: kos.images.isEmpty
                        ? const Icon(Icons.home, size: 50, color: Colors.grey)
                        : null,
                  ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<KosController>(
                      builder: (context, controller, child) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            onTap: () => controller.toggleFavorite(kos),
                            child: Icon(
                              controller.isFavorite(kos)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: controller.isFavorite(kos)
                                  ? Colors.red
                                  : Colors.grey,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Content with Flexible layout
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        kos.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 12,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              kos.address,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        'Rp ${kos.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}/bulan',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKosListCard(Kos kos) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _navigateToDetail(kos),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: kos.images.isNotEmpty
                      ? DecorationImage(
                          image: AssetImage(kos.images.first),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: Colors.grey[300],
                ),
                child: kos.images.isEmpty
                    ? const Icon(Icons.home, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 16),

              // Content with Flexible
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kos.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            kos.address,
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            'Rp ${kos.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}/bulan',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Consumer<KosController>(
                            builder: (context, controller, child) {
                              return IconButton(
                                icon: Icon(
                                  controller.isFavorite(kos)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: controller.isFavorite(kos)
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () => controller.toggleFavorite(kos),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String category) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Tidak ada kos $category',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba ubah filter pencarian Anda',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(Kos kos) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KosDetailScreen(kos: kos)),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Pencarian'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Urutkan berdasarkan:'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children:
                      [
                        'Harga Terendah',
                        'Harga Tertinggi',
                        'Rating Tertinggi',
                        'Jarak Terdekat',
                        'Terbaru',
                      ].map((option) {
                        return FilterChip(
                          label: Text(option),
                          selected: false,
                          onSelected: (selected) {
                            // Apply sorting
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                ),
              ],
            ),
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

  void _showAddKosDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Kos Baru'),
          content: const Text(
            'Fitur untuk menambah kos baru akan segera tersedia.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to add kos screen
              },
              child: const Text('Lanjutkan'),
            ),
          ],
        );
      },
    );
  }
}
