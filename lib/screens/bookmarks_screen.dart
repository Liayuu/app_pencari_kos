// Updated bookmark texts from "favorit" to "bookmark"
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/kos_controller.dart';
import '../models/kos.dart';
import 'kos_detail_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen>
    with TickerProviderStateMixin {
  late AnimationController _listAnimationController;
  late AnimationController _fabAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isSelectionMode = false;
  Set<String> _selectedItems = {};
  String _sortBy = 'name';

  @override
  void initState() {
    super.initState();

    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _listAnimationController,
            curve: Curves.elasticOut,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _listAnimationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _listAnimationController.forward();
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSelectionMode
              ? Text(
                  '${_selectedItems.length} dipilih',
                  key: const ValueKey('selection'),
                )
              : const Text('Kos Bookmark', key: ValueKey('title')),
        ),
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _selectedItems.isNotEmpty ? _deleteSelected : null,
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _exitSelectionMode,
            ),
          ] else ...[
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort),
              onSelected: (String value) {
                setState(() {
                  _sortBy = value;
                });
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'name',
                  child: Row(
                    children: [
                      Icon(Icons.sort_by_alpha),
                      SizedBox(width: 8),
                      Text('Nama'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'price',
                  child: Row(
                    children: [
                      Icon(Icons.monetization_on),
                      SizedBox(width: 8),
                      Text('Harga'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'rating',
                  child: Row(
                    children: [
                      Icon(Icons.star),
                      SizedBox(width: 8),
                      Text('Rating'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'distance',
                  child: Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 8),
                      Text('Jarak'),
                    ],
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.checklist),
              onPressed: _enterSelectionMode,
            ),
          ],
        ],
      ),
      body: Consumer<KosController>(
        builder: (context, kosController, child) {
          final bookmarkedKos = _getSortedBookmarks(kosController.favoriteKos);

          if (bookmarkedKos.isEmpty) {
            return _buildEmptyState();
          }

          return SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookmarkedKos.length,
                itemBuilder: (context, index) {
                  final kos = bookmarkedKos[index];
                  return _buildBookmarkCard(kos, index, kosController);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: Consumer<KosController>(
        builder: (context, kosController, child) {
          if (kosController.favoriteKos.isEmpty) {
            return const SizedBox();
          }

          return ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isSelectionMode) ...[
                  FloatingActionButton(
                    heroTag: "share",
                    mini: true,
                    onPressed: _shareAllBookmarks,
                    child: const Icon(Icons.share),
                  ),
                  const SizedBox(height: 8),
                ],
                FloatingActionButton(
                  heroTag: "main",
                  onPressed: _isSelectionMode ? _selectAll : _showFilterOptions,
                  child: Icon(
                    _isSelectionMode ? Icons.select_all : Icons.filter_list,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookmarkCard(Kos kos, int index, KosController controller) {
    final isSelected = _selectedItems.contains(kos.id);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: 16, top: index == 0 ? 0 : 0),
      transform: Matrix4.identity()..translate(isSelected ? 8.0 : 0.0),
      child: Card(
        elevation: isSelected ? 8 : 4,
        color: isSelected ? Colors.blue.shade50 : null,
        child: InkWell(
          onTap: () {
            if (_isSelectionMode) {
              _toggleSelection(kos.id);
            } else {
              _navigateToDetail(kos);
            }
          },
          onLongPress: () {
            if (!_isSelectionMode) {
              _enterSelectionMode();
              _toggleSelection(kos.id);
            }
          },
          child: Stack(
            children: [
              // Main Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Image
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: Colors.blue, width: 2)
                            : null,
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
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  kos.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getTypeColor(kos.type),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  kos.type,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
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
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Price and Rating row
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
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      kos.rating.toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Facilities preview
                          if (kos.facilities.isNotEmpty)
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: kos.facilities.take(3).map((facility) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    facility,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Selection indicator
              if (_isSelectionMode)
                Positioned(
                  top: 8,
                  right: 8,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Colors.blue : Colors.grey[300],
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ),

              // Bookmark button (when not in selection mode)
              if (!_isSelectionMode)
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () => controller.toggleFavorite(kos),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.bookmark,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Belum ada kos yang di-bookmark',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tambahkan kos ke bookmark dengan menekan ikon bookmark',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.search),
            label: const Text('Cari Kos'),
          ),
        ],
      ),
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

  List<Kos> _getSortedBookmarks(List<Kos> bookmarks) {
    final sorted = List<Kos>.from(bookmarks);

    switch (_sortBy) {
      case 'name':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'price':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'rating':
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'distance':
        sorted.sort(
          (a, b) => a.distanceToUniversity.compareTo(b.distanceToUniversity),
        );
        break;
    }

    return sorted;
  }

  void _navigateToDetail(Kos kos) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KosDetailScreen(kos: kos)),
    );
  }

  void _enterSelectionMode() {
    setState(() {
      _isSelectionMode = true;
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedItems.clear();
    });
  }

  void _toggleSelection(String kosId) {
    setState(() {
      if (_selectedItems.contains(kosId)) {
        _selectedItems.remove(kosId);
      } else {
        _selectedItems.add(kosId);
      }
    });
  }

  void _selectAll() {
    final controller = Provider.of<KosController>(context, listen: false);
    setState(() {
      if (_selectedItems.length == controller.favoriteKos.length) {
        _selectedItems.clear();
      } else {
        _selectedItems = controller.favoriteKos.map((kos) => kos.id).toSet();
      }
    });
  }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus dari Bookmark'),
          content: Text(
            'Apakah Anda yakin ingin menghapus ${_selectedItems.length} kos dari bookmark?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final controller = Provider.of<KosController>(
                  context,
                  listen: false,
                );
                for (final kosId in _selectedItems) {
                  final kos = controller.favoriteKos.firstWhere(
                    (k) => k.id == kosId,
                  );
                  controller.toggleFavorite(kos);
                }
                Navigator.pop(context);
                _exitSelectionMode();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kos berhasil dihapus dari favorit'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _shareAllBookmarks() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bagikan Bookmark'),
          content: const Text(
            'Fitur berbagi daftar favorit akan segera tersedia.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter & Urutkan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              const Text(
                'Urutkan berdasarkan:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Nama'),
                    selected: _sortBy == 'name',
                    onSelected: (selected) {
                      setState(() {
                        _sortBy = 'name';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  FilterChip(
                    label: const Text('Harga'),
                    selected: _sortBy == 'price',
                    onSelected: (selected) {
                      setState(() {
                        _sortBy = 'price';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  FilterChip(
                    label: const Text('Rating'),
                    selected: _sortBy == 'rating',
                    onSelected: (selected) {
                      setState(() {
                        _sortBy = 'rating';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  FilterChip(
                    label: const Text('Jarak'),
                    selected: _sortBy == 'distance',
                    onSelected: (selected) {
                      setState(() {
                        _sortBy = 'distance';
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
