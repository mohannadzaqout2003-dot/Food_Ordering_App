import 'dart:async';
import 'package:flutter/material.dart';

class SearchProduct extends ChangeNotifier {
  String _query = '';
  Timer? _debounce;

  String get query => _query;

  bool get hasQuery => _query.trim().isNotEmpty;

  bool get isSearching => hasQuery;

  void updateQuery(String value) {
    if (value == _query) return;

    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 250), () {
      _query = value;
      notifyListeners();
    });
  }

  void clear() {
    if (_query.isEmpty) return;

    _query = '';
    notifyListeners();
  }

  void setQuerySilently(String value) {
    _query = value;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
