import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:restaurant_app/api/api_setting.dart';
import 'package:restaurant_app/api/auth_service.dart';
import 'package:restaurant_app/api/favorite_service.dart';
import 'package:restaurant_app/model/product_model.dart';

class CategoryProduct extends ChangeNotifier {
  int _currentCategory = 0;
  int get currentCategory => _currentCategory;

  final List<String> categories = [
    "NEARBY",
    "POPULAR",
    "TOP REVIEW",
    "RECOMMENDED",
    "DRINKS",
    "DESSERTS",
  ];

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final _auth = AuthService.instance;
  final _favoriteService = FavoriteService.instance;

  Future<void> loadProducts() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await http.get(ApiURL.product.uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final list = data['product'] as List;

        _products = list.map((e) => Product.fromJson(e)).toList();

        final user = _auth.currentUser;
        if (user != null) {
          final favKeys = await _favoriteService.getFavoritesKeys(user.uid);
          for (final p in _products) {
            p.isFavorite = favKeys.contains(p.favoriteKey);
          }
        }
      } else {
        _errorMessage = 'Failed to load products (${response.statusCode})';
        debugPrint('failed to load data ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = 'Error loading products';
      debugPrint('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void changeCategory(int index) {
    _currentCategory = index;
    notifyListeners();
  }

  List<Product> get productsByCategory {
    switch (_currentCategory) {
      case 0: // NEARBY
        return _products.where((p) => p.category == 'nearby').toList();
      case 1: // POPULAR
        return _products.where((p) => p.category == 'popular').toList();
      case 2: // TOP REVIEW
        return _products.where((p) => p.category == 'top_review').toList();
      case 3: // RECOMMENDED
        return _products.where((p) => p.category == 'recommended').toList();
      case 4: // DRINKS
        return _products.where((p) => p.category == 'drinks').toList();
      case 5: // DESSERTS
        return _products.where((p) => p.category == 'desserts').toList();
      default:
        return _products;
    }
  }

  Future<void> toggleFavorite(int index) async {
    if (index < 0 || index >= _products.length) return;

    final product = _products[index];
    final oldValue = product.isFavorite;

    product.isFavorite = !product.isFavorite;
    notifyListeners();

    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _favoriteService.setFavorite(
        userId: user.uid,
        productKey: product.favoriteKey,
        isFavorite: product.isFavorite,
      );
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      product.isFavorite = oldValue;
      notifyListeners();
    }
  }
}
