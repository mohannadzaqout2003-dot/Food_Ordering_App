import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItemModel {
  final String productKey;
  final String name;
  final String image;
  final double price;
  final int quantity;
  final double totalPrice;

  OrderItemModel({
    required this.productKey,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.totalPrice,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productKey: map['productKey'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: (map['quantity'] ?? 0) as int,
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
    );
  }
}

class OrderModel {
  final String id;
  final String userId;
  final double totalPrice;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    final rawItems = (data['items'] as List<dynamic>? ?? []);
    final items = rawItems
        .map((e) => OrderItemModel.fromMap((e as Map).cast<String, dynamic>()))
        .toList();

    final ts = data['createdAt'];
    final createdAt = ts is Timestamp
        ? ts.toDate()
        : DateTime.fromMillisecondsSinceEpoch(0);

    return OrderModel(
      id: data['id'] ?? doc.id,
      userId: data['userId'] ?? '',
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'] ?? '',
      paymentStatus: data['paymentStatus'] ?? '',
      createdAt: createdAt,
      items: items,
    );
  }
}
