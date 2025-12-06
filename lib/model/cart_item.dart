import 'package:restaurant_app/model/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'name': product.name,
      'image': product.image,
      'price': product.price,
      'quantity': quantity,
    };
  }
}
