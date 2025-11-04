// lib/providers/meal_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import '../models/meal.dart';

class MealProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  List<Meal> _meals = [];
  List<String> _favoriteMealIds = []; // Store only IDs for favorites
  List<Meal> _favoriteMeals = []; // Store actual Meal objects for display

  bool get isLoading => _isLoading;
  List<Meal> get meals => _meals;
  Meal? _randomMeal;
  Meal? get randomMeal => _randomMeal;
  List<Meal> get favoriteMeals => _favoriteMeals;

  MealProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteMealIds = prefs.getStringList('favoriteMealIds') ?? [];
    await _fetchFavoriteMeals(); // Fetch actual meal objects
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoriteMealIds', _favoriteMealIds);
  }

  Future<void> _fetchFavoriteMeals() async {
    _favoriteMeals = []; // Clear existing favorites
    for (String id in _favoriteMealIds) {
      try {
        final meal = await _apiService.getMealDetail(id);
        _favoriteMeals.add(meal);
      } catch (e) {
        print('Error fetching favorite meal $id: $e');
      }
    }
    notifyListeners();
  }

  void toggleFavorite(Meal meal) {
    if (_favoriteMealIds.contains(meal.id)) {
      _favoriteMealIds.remove(meal.id);
      _favoriteMeals.removeWhere((favMeal) => favMeal.id == meal.id);
    } else {
      _favoriteMealIds.add(meal.id);
      _favoriteMeals.add(meal); // Add the meal directly for immediate display
    }
    _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(Meal meal) {
    return _favoriteMealIds.contains(meal.id);
  }

  Future<Meal?> fetchRandomMeal() async {
    try {
      final meal = await _apiService.getRandomMeal();
      _randomMeal = meal;
      notifyListeners();
      return meal;
    } catch (e) {
      // Handle error
      print('Error fetching random meal: $e');
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
      print('Error fetching meals: $e');
    }

    _isLoading = false;
    notifyListeners(); // Notify widgets that loading is complete and data is ready
  }

  Future<void> fetchMealsByCategory(String categoryName) async {
    _isLoading = true;
    notifyListeners();

    try {
      _meals = await _apiService.getMealsByCategory(categoryName);
    } catch (e) {
      print('Error fetching meals by category: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}