import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/kos_controller.dart';
import '../controllers/search_controller.dart' as search_ctrl;
import '../models/kos.dart';
import 'kos_detail_screen.dart';

class GridViewKosScreen extends StatefulWidget {
  const GridViewKosScreen({super.key});

  @override
  State<GridViewKosScreen> createState() => _GridViewKosScreenState();
}

class _GridViewKosScreenState extends State<GridViewKosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Grid View Kos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.view_list),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: 'Switch to List View',
          ),
        ],
      ),
      body: Consumer2<KosController, search_ctrl.SearchController>(
        builder: (context, kosController, searchController, child) {
          final filteredKos = searchController.applyFilters(
            kosController.allKos,
          );

          if (kosController.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat data kos...', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }

          if (filteredKos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_work, size: 80, color: Colors.grey.shade400),
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
                    'Coba ubah filter pencarian Anda',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      searchController.resetFilters();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Filter'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF1976D2).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF1976D2)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Ditemukan ${filteredKos.length} kos sesuai kriteria',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Grid View dengan GridView.count
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: filteredKos.map((kos) {
                    return _buildKosGridItem(context, kos, kosController);
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Alternative GridView.builder untuk performa lebih baik
                const Text(
                  'GridView Builder (Better Performance)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 400,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                    itemCount: filteredKos.length,
                    itemBuilder: (context, index) {
                      final kos = filteredKos[index];
                      return _buildHorizontalKosGridItem(
                        context,
                        kos,
                        kosController,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showGridOptionsDialog(context);
        },
        icon: const Icon(Icons.grid_view),
        label: const Text('Grid Options'),
      ),
    );
  }

  Widget _buildKosGridItem(
    BuildContext context,
    Kos kos,
    KosController controller,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => KosDetailScreen(kos: kos)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section with Stack
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey.shade200),
                        child: kos.images.isNotEmpty
                            ? Image.asset(
                                kos.images.first,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade300,
                                    child: const Center(
                                      child: Icon(
                                        Icons.home,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: Colors.grey.shade300,
                                child: const Center(
                                  child: Icon(
                                    Icons.home,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                      ),

                      // Type badge
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(kos.type),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            kos.type,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      // Favorite button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            controller.toggleFavorite(kos);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              controller.isFavorite(kos)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: controller.isFavorite(kos)
                                  ? Colors.red
                                  : Colors.grey,
                              size: 16,
                            ),
                          ),
                        ),
                      ),

                      // Rating badge
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                kos.rating.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content section
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        Text(
                          kos.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        // Distance
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.grey,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                '${kos.distanceToUniversity} km',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Price
                        Text(
                          'Rp ${_formatPrice(kos.price)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1976D2),
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          'per bulan',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalKosGridItem(
    BuildContext context,
    Kos kos,
    KosController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact image
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: kos.images.isNotEmpty
                  ? Image.asset(
                      kos.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.home, size: 30, color: Colors.grey),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(Icons.home, size: 30, color: Colors.grey),
                    ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kos.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        kos.rating.toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'Rp ${_formatPrice(kos.price)}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
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

  void _showGridOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Grid Options',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.grid_3x3),
                title: const Text('2 Columns'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement 2 column grid
                },
              ),
              ListTile(
                leading: const Icon(Icons.grid_4x4),
                title: const Text('3 Columns'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement 3 column grid
                },
              ),
              ListTile(
                leading: const Icon(Icons.view_list),
                title: const Text('List View'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Go back to list view
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Putra':
        return Colors.blue;
      case 'Putri':
        return Colors.pink;
      case 'Campur':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatPrice(int price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)} jt';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)} rb';
    } else {
      return price.toString();
    }
  }
}
