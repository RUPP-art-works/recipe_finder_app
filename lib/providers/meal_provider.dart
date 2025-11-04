// lib/providers/meal_provider.dart

import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/meal.dart';

class MealProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  List<Meal> _meals = [];

  bool get isLoading => _isLoading;
  List<Meal> get meals => _meals;
  Meal? _randomMeal;
  Meal? get randomMeal => _randomMeal;

  Future<Meal?> fetchRandomMeal() async {
    try {
      final meal = await _apiService.getRandomMeal();
      return meal;
    } catch (e) {
      // Handle error
      return null;
    }
  }

  Future<void> fetchMeals() async {
    _isLoading = true;
    notifyListeners(); // Notify widgets that we are starting to load

    try {
      _meals = await _apiService.getMeals();
    } catch (e) {
      // Handle error, for example, by setting an error message
      // print(e); // Consider logging the error instead of printing
    }

    _isLoading = false;
    notifyListeners(); // Notify widgets that loading is complete and data is ready
  }
}
