// lib/providers/category_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../api/api_service.dart';
import '../models/category.dart' as models;

class CategoryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<models.Category> _categories = [];
  bool _isLoading = false;
  String? _selectedCategory; // Can be null if nothing is selected

  List<models.Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get selectedCategory => _selectedCategory;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await _apiService.getCategories();
    } catch (e) {
      debugPrint(e.toString());
    }
    _isLoading = false;
    notifyListeners();
  }

  void selectCategory(String categoryName) {
    if (_selectedCategory == categoryName) {
      // If the same category is tapped again, deselect it
      _selectedCategory = null;
    } else {
      _selectedCategory = categoryName;
    }
    notifyListeners();
  }
}
