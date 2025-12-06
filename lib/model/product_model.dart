class Product {
  String name;
  double price;
  String image;
  bool isFavorite;
  String category;
  String description;

  Product({
    required this.name,
    required this.price,
    required this.image,
    this.isFavorite = false,
    required this.category,
    required this.description,
  });

  String get favoriteKey => '${name}_$image'.hashCode.toString();

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
      category: json['category'] ?? 'nearby',
      description: json['description'] ?? '',
    );
  }
}
