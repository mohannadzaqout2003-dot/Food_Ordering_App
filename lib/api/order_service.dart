import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/model/cart_item.dart';

class OrderService {
  OrderService._();
  static final OrderService instance = OrderService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder({
    required String userId,
    required List<CartItem> items,
    required double totalPrice,
  }) async {
    final ordersRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('orders');

    final orderData = {
      'totalPrice': totalPrice,
      'createdAt': FieldValue.serverTimestamp(),
      'items': items.map((item) {
        return {
          'name': item.product.name,
          'price': item.product.price,
          'image': item.product.image,
          'quantity': item.quantity,
          'productKey': item.product.favoriteKey,
        };
      }).toList(),
    };
    try {
      await ordersRef.add(orderData);
    } catch (e) {
      debugPrint('Error creating order: $e');
      rethrow;
    }

    await ordersRef.add(orderData);
  }
}
