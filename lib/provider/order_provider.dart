import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/api/auth_service.dart';
import 'package:restaurant_app/model/order_model.dart';



class OrdersProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = AuthService.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  Future<void> loadOrders() async {
    final user = _auth.currentUser;

    if (user == null) {
      _orders = [];
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      _orders = snapshot.docs
          .map((doc) => OrderModel.fromDoc(doc))
          .toList();
    } catch (e) {
      debugPrint('Error loading orders: $e');
      _errorMessage = "Failed to load orders.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadOrders();
  }
}
