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
        // Handle error
      }
    }
    notifyListeners();
  }

  void toggleFavorite(Meal meal) {
    debugPrint('Toggling favorite for meal: ${meal.name} (ID: ${meal.id})');
    if (_favoriteMealIds.contains(meal.id)) {
      debugPrint('Meal is currently a favorite. Removing it.');
      _favoriteMealIds.remove(meal.id);
      _favoriteMeals.removeWhere((favMeal) => favMeal.id == meal.id);
    } else {
      debugPrint('Meal is not a favorite. Adding it.');
      _favoriteMealIds.add(meal.id);
      _favoriteMeals.add(meal); // Add the meal directly for immediate display
    }
    debugPrint('Favorite IDs are now: $_favoriteMealIds');
    _saveFavorites();
    debugPrint('Favorites saved. Notifying listeners.');
    notifyListeners();
  }

  bool isFavorite(Meal meal) {
    return _favoriteMealIds.contains(meal.id);
  }

  Future<List<Meal>> fetchMultipleRandomMeals(int count) async {
    try {
      final meals = await _apiService.getMultipleRandomMeals(count);
      return meals;
    } catch (e) {
      return [];
    }
  }

  Future<Meal?> fetchRandomMeal() async {
    try {
      final meal = await _apiService.getRandomMeal();
      _randomMeal = meal;
      notifyListeners();
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
    }

    _isLoading = false;
    notifyListeners(); // Notify widgets that loading is complete and data is ready
  }

  Future<List<Meal>> fetchMealsByCategory(String categoryName) async {
    _isLoading = true;
    notifyListeners();

    try {
      final meals = await _apiService.getMealsByCategory(categoryName);
      _meals = meals;
      return meals;
    } catch (e) {
      return [];
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}