import 'package:flutter/material.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  bool read;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
  });

  bool get isRead => read;
  DateTime get time => createdAt;
}

class NotificationProvider extends ChangeNotifier {
  final List<AppNotification> _items = [];

  List<AppNotification> get notifications => List.unmodifiable(_items);

  bool get hasNotifications => _items.isNotEmpty;

  int get unreadCount => _items.where((n) => !n.read).length;

  NotificationProvider() {
    _seedDummyNotifications();
  }

  void _seedDummyNotifications() {
    if (_items.isNotEmpty) return;

    _items.addAll([
      AppNotification(
        id: '1',
        title: 'Welcome 🎉',
        body: 'Thanks for using Food App!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      AppNotification(
        id: '2',
        title: 'Special offer',
        body: 'Get 35% discount on your first order.',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ]);

    notifyListeners();
  }

  void addNotification({required String title, required String body}) {
    _items.insert(
      0,
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _items.indexWhere((n) => n.id == id);
    if (index == -1) return;

    if (!_items[index].read) {
      _items[index].read = true;
      notifyListeners();
    }
  }

  void markAllRead() {
    for (final n in _items) {
      n.read = true;
    }
    notifyListeners();
  }

  void deleteNotification(String id) {
    _items.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearAll() {
    _items.clear();
    notifyListeners();
  }
}
