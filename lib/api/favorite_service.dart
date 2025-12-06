
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoriteService {
  FavoriteService._();
  static final FavoriteService instance = FavoriteService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setFavorite({
    required String userId,
    required String productKey,
    required bool isFavorite,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(productKey);

    try {
      if (isFavorite) {
        await docRef.set({'isFavorite': true});
      } else {
        await docRef.delete();
      }
    } catch (e) {
      debugPrint('Error setFavorite: $e');
      rethrow;
    }
  }

  Future<Set<String>> getFavoritesKeys(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();

    return snapshot.docs.map((doc) => doc.id).toSet();
  }
}
