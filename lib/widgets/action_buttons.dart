import 'package:flutter/material.dart';

/// Collection of action buttons used throughout the app
class ActionButtons {
  /// Create a standard floating action button
  static Widget floatingActionButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required IconData icon,
    String? tooltip,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      foregroundColor: foregroundColor ?? Colors.white,
      child: Icon(icon),
    );
  }

  /// Create an extended floating action button
  static Widget extendedFloatingActionButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    String? tooltip,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      label: Text(label),
      icon: Icon(icon),
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      foregroundColor: foregroundColor ?? Colors.white,
    );
  }

  /// Location button for map screen
  static Widget locationButton(BuildContext context, VoidCallback onPressed) {
    return floatingActionButton(
      context: context,
      onPressed: onPressed,
      icon: Icons.my_location,
      tooltip: 'Lokasi Saya',
    );
  }

  /// Filter button for search/list screens
  static Widget filterButton(BuildContext context, VoidCallback onPressed) {
    return floatingActionButton(
      context: context,
      onPressed: onPressed,
      icon: Icons.filter_alt,
      tooltip: 'Filter',
    );
  }

  /// Share button for bookmark screen
  static Widget shareButton(BuildContext context, VoidCallback onPressed) {
    return floatingActionButton(
      context: context,
      onPressed: onPressed,
      icon: Icons.share,
      tooltip: 'Bagikan',
    );
  }

  /// Add button for various screens
  static Widget addButton(
    BuildContext context,
    VoidCallback onPressed, {
    String? tooltip,
  }) {
    return floatingActionButton(
      context: context,
      onPressed: onPressed,
      icon: Icons.add,
      tooltip: tooltip ?? 'Tambah',
    );
  }

  /// Advanced search button
  static Widget advancedSearchButton(
    BuildContext context,
    VoidCallback onPressed,
  ) {
    return extendedFloatingActionButton(
      context: context,
      onPressed: onPressed,
      label: 'Pencarian Lanjutan',
      icon: Icons.tune,
      tooltip: 'Pencarian Lanjutan',
    );
  }

  /// Sort button for list screens
  static Widget sortButton(BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.sort),
      tooltip: 'Urutkan',
    );
  }

  /// Grid/List view toggle button
  static Widget viewToggleButton({
    required BuildContext context,
    required bool isGridView,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
      tooltip: isGridView ? 'Tampilan List' : 'Tampilan Grid',
    );
  }

  /// Search button for app bars
  static Widget searchButton(BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.search),
      tooltip: 'Cari',
    );
  }

  /// Bookmark button for app bars
  static Widget bookmarkButton(BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.bookmark),
      tooltip: 'Bookmark',
    );
  }

  /// More options button (three dots)
  static Widget moreButton(BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.more_vert),
      tooltip: 'Opsi Lainnya',
    );
  }

  /// Back button
  static Widget backButton(BuildContext context, {VoidCallback? onPressed}) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back),
      tooltip: 'Kembali',
    );
  }

  /// Close button
  static Widget closeButton(BuildContext context, {VoidCallback? onPressed}) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.pop(context),
      icon: const Icon(Icons.close),
      tooltip: 'Tutup',
    );
  }

  /// Help button
  static Widget helpButton(BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.help_outline),
      tooltip: 'Bantuan',
    );
  }

  /// Refresh button
  static Widget refreshButton(BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh),
      tooltip: 'Muat Ulang',
    );
  }

  /// Edit button
  static Widget editButton(BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.edit),
      tooltip: 'Edit',
    );
  }

  /// Delete button
  static Widget deleteButton(BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.delete),
      tooltip: 'Hapus',
      color: Colors.red[600],
    );
  }

  /// Favorite/Heart button
  static Widget favoriteButton({
    required BuildContext context,
    required bool isFavorite,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : null,
      ),
      tooltip: isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
    );
  }

  /// Bookmark toggle button
  static Widget bookmarkToggleButton({
    required BuildContext context,
    required bool isBookmarked,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: isBookmarked ? Colors.blue : null,
      ),
      tooltip: isBookmarked ? 'Hapus dari Bookmark' : 'Tambah ke Bookmark',
    );
  }

  /// Call button
  static Widget callButton(BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.phone),
      tooltip: 'Telepon',
      color: Colors.green[600],
    );
  }

  /// Message button
  static Widget messageButton(BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.message),
      tooltip: 'Pesan',
      color: Colors.blue[600],
    );
  }

  /// Download button
  static Widget downloadButton(BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.download),
      tooltip: 'Unduh',
    );
  }

  /// Upload button
  static Widget uploadButton(BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.upload),
      tooltip: 'Unggah',
    );
  }

  /// Custom button with text and icon
  static Widget customButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
    EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        text,
        style: TextStyle(fontSize: fontSize ?? 14, color: textColor),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        foregroundColor: textColor ?? Colors.white,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
