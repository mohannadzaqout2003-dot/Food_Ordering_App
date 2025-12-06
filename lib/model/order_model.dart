import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItemModel {
  final String name;
  final double price;
  final String image;
  final int quantity;
  final String productKey;

  OrderItemModel({
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    required this.productKey,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      image: map['image'] ?? '',
      quantity: map['quantity'] ?? 1,
      productKey: map['productKey'] ?? '',
    );
  }
}

class OrderModel {
  final String id;
  final double totalPrice;
  final DateTime? createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.totalPrice,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final itemsList = (data['items'] as List<dynamic>? ?? [])
        .map((e) => OrderItemModel.fromMap(e as Map<String, dynamic>))
        .toList();

    return OrderModel(
      id: doc.id,
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      items: itemsList,
    );
  }
}
