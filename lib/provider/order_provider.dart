import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app/model/order_model.dart';

class OrdersProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;

  Future<void> loadOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _orders.clear();
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final snap = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .get();

      _orders
        ..clear()
        ..addAll(snap.docs.map((doc) => OrderModel.fromFirestore(doc)));
    } catch (e, st) {
      debugPrint('Error loading orders: $e');
      debugPrintStack(stackTrace: st);
      _orders.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
