import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Notifikasi'),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Tandai Semua',
                style: TextStyle(color: Colors.white),
              ),
            ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'clear_all':
                  _clearAllNotifications();
                  break;
                case 'settings':
                  _showNotificationSettings();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Hapus Semua'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Pengaturan'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada notifikasi',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationCard(notification);
              },
            ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: notification.isRead ? 1 : 3,
        color: notification.isRead ? null : Colors.blue[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getNotificationColor(notification.type),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getNotificationIcon(notification.type),
              color: Colors.white,
              size: 20,
            ),
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: notification.isRead
                  ? FontWeight.normal
                  : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification.message,
                style: TextStyle(
                  color: notification.isRead
                      ? Colors.grey[600]
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTime(notification.time),
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'mark_read':
                  _markAsRead(notification.id);
                  break;
                case 'delete':
                  _deleteNotification(notification.id);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              if (!notification.isRead)
                const PopupMenuItem<String>(
                  value: 'mark_read',
                  child: Row(
                    children: [
                      Icon(Icons.mark_email_read),
                      SizedBox(width: 8),
                      Text('Tandai Dibaca'),
                    ],
                  ),
                ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Hapus', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
          onTap: () {
            if (!notification.isRead) {
              _markAsRead(notification.id);
            }
            _handleNotificationTap(notification);
          },
        ),
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
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

  IconData _getNotificationIcon(NotificationType type) {
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

  String _formatTime(DateTime time) {
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

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifikasi dihapus'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Semua Notifikasi'),
          content: const Text(
            'Apakah Anda yakin ingin menghapus semua notifikasi?',
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
                setState(() {
                  _notifications.clear();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Semua notifikasi dihapus'),
                    backgroundColor: Colors.red,
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

  void _showNotificationSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationSettingsScreen(),
      ),
    );
  }

  void _handleNotificationTap(NotificationItem notification) {
    switch (notification.type) {
      case NotificationType.booking:
        // Navigate to booking details
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Membuka detail booking')));
        break;
      case NotificationType.message:
        // Navigate to chat
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Membuka chat')));
        break;
      case NotificationType.newKos:
        // Navigate to kos details
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Membuka kos baru')));
        break;
      case NotificationType.payment:
        // Navigate to payment
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Membuka pembayaran')));
        break;
      case NotificationType.update:
        // Navigate to kos update
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Melihat update fasilitas')),
        );
        break;
    }
  }
}

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

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _bookingNotifications = true;
  bool _messageNotifications = true;
  bool _newKosNotifications = true;
  bool _paymentNotifications = true;
  bool _updateNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Notifikasi')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notifikasi Booking'),
            subtitle: const Text('Terima notifikasi untuk konfirmasi booking'),
            value: _bookingNotifications,
            onChanged: (value) {
              setState(() {
                _bookingNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Notifikasi Pesan'),
            subtitle: const Text('Terima notifikasi pesan baru'),
            value: _messageNotifications,
            onChanged: (value) {
              setState(() {
                _messageNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Notifikasi Kos Baru'),
            subtitle: const Text('Terima notifikasi kos baru di area favorit'),
            value: _newKosNotifications,
            onChanged: (value) {
              setState(() {
                _newKosNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Notifikasi Pembayaran'),
            subtitle: const Text('Terima pengingat pembayaran'),
            value: _paymentNotifications,
            onChanged: (value) {
              setState(() {
                _paymentNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Notifikasi Update'),
            subtitle: const Text('Terima notifikasi update fasilitas'),
            value: _updateNotifications,
            onChanged: (value) {
              setState(() {
                _updateNotifications = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
