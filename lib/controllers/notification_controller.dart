import 'package:flutter/material.dart';

enum NotificationType { booking, message, newKos, payment, update }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final NotificationType type;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? time,
    NotificationType? type,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationController extends ChangeNotifier {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Booking Dikonfirmasi',
      message: 'Booking Anda untuk Kos Melati telah dikonfirmasi oleh pemilik.',
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      type: NotificationType.booking,
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Pesan Baru',
      message: 'Anda memiliki pesan baru dari pemilik Kos Mawar.',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.message,
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Kos Baru Tersedia',
      message: 'Ada kos baru di area yang Anda cari: Kos Anggrek Premium.',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      type: NotificationType.newKos,
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Pengingat Pembayaran',
      message: 'Pembayaran sewa kos bulan ini akan jatuh tempo dalam 3 hari.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.payment,
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'Update Fasilitas',
      message: 'Kos Seruni telah menambahkan fasilitas WiFi baru.',
      time: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.update,
      isRead: true,
    ),
  ];

  // Notification settings
  bool _bookingNotifications = true;
  bool _messageNotifications = true;
  bool _newKosNotifications = true;
  bool _paymentNotifications = true;
  bool _updateNotifications = false;

  // Getters
  List<NotificationItem> get notifications => _notifications;
  List<NotificationItem> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  bool get bookingNotifications => _bookingNotifications;
  bool get messageNotifications => _messageNotifications;
  bool get newKosNotifications => _newKosNotifications;
  bool get paymentNotifications => _paymentNotifications;
  bool get updateNotifications => _updateNotifications;

  // Add new notification
  void addNotification(NotificationItem notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  // Mark as read
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  // Mark all as read
  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  // Delete notification
  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  // Clear all notifications
  void clearAllNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  // Update notification settings
  void updateBookingNotifications(bool value) {
    _bookingNotifications = value;
    notifyListeners();
  }

  void updateMessageNotifications(bool value) {
    _messageNotifications = value;
    notifyListeners();
  }

  void updateNewKosNotifications(bool value) {
    _newKosNotifications = value;
    notifyListeners();
  }

  void updatePaymentNotifications(bool value) {
    _paymentNotifications = value;
    notifyListeners();
  }

  void updateUpdateNotifications(bool value) {
    _updateNotifications = value;
    notifyListeners();
  }

  // Get notification icon
  IconData getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Icons.bookmark_added;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.newKos:
        return Icons.home_work;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.update:
        return Icons.update;
    }
  }

  // Get notification color
  Color getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Colors.green;
      case NotificationType.message:
        return Colors.blue;
      case NotificationType.newKos:
        return Colors.orange;
      case NotificationType.payment:
        return Colors.red;
      case NotificationType.update:
        return Colors.purple;
    }
  }

  // Format time
  String formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  // Handle notification tap
  void handleNotificationTap(
    NotificationItem notification,
    BuildContext context,
  ) {
    if (!notification.isRead) {
      markAsRead(notification.id);
    }

    switch (notification.type) {
      case NotificationType.booking:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Membuka detail booking')));
        break;
      case NotificationType.message:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Membuka chat')));
        break;
      case NotificationType.newKos:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Membuka kos baru')));
        break;
      case NotificationType.payment:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Membuka pembayaran')));
        break;
      case NotificationType.update:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Melihat update fasilitas')),
        );
        break;
    }
  }
}
