import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/model/cart_item.dart';
import 'package:restaurant_app/model/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);

  void addToCart(Product product) {
    final index = _items.indexWhere(
      (item) => item.product.favoriteKey == product.favoriteKey,
    );

    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }

    notifyListeners();
  }

  Future<void> checkout({
    required String userId,
    required String paymentMethod,
    required String paymentStatus,
  }) async {
    if (_items.isEmpty) return;

    final orderRef = FirebaseFirestore.instance.collection('orders').doc();

    final orderData = {
      'id': orderRef.id,
      'userId': userId,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'createdAt': FieldValue.serverTimestamp(),
      'items': _items
          .map(
            (item) => {
              'productKey': item.product.favoriteKey,
              'name': item.product.name,
              'image': item.product.image,
              'price': item.product.price,
              'quantity': item.quantity,
              'totalPrice': item.totalPrice,
            },
          )
          .toList(),
    };

    await orderRef.set(orderData);

    _items.clear();
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _items.removeWhere(
      (item) => item.product.favoriteKey == product.favoriteKey,
    );
    notifyListeners();
  }

  void increaseQty(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decreaseQty(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
