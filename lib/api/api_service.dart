// lib/api/api_service.dart
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation; // for debugPrint
import '../models/meal.dart';
import '../models/category.dart';

class ApiService {
  final String _baseUrl = 'https://meal-db-sandy.vercel.app';

  // IMPORTANT: Make sure this matches the GUID you tested in Postman
  final Map<String, String> _headers = {
    'X-DB-NAME': 'e5c213ef-7c04-4961-a5da-12a3667228b4',
  };

  // 🔹 Fetch all meals
  Future<List<Meal>> getMeals() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/meals'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Meal> meals =
          body.map((dynamic item) => Meal.fromJson(item)).toList();
      return meals;
    } else {
      throw Exception('Failed to load meals');
    }
  }

  // 🔹 Fetch multiple random meals
  Future<List<Meal>> getMultipleRandomMeals(int count) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/meals'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Meal> meals =
          body.map((dynamic item) => Meal.fromJson(item)).toList();
      meals.shuffle();
      return meals.take(count).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  // 🔹 Fetch a single random meal
  Future<Meal> getRandomMeal() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/meals'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Meal> meals =
          body.map((dynamic item) => Meal.fromJson(item)).toList();
      final random = Random();
      return meals[random.nextInt(meals.length)];
    } else {
      throw Exception('Failed to load meals');
    }
  }

  // 🔹 Fetch all categories
  Future<List<Category>> getCategories() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/categories'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Category> categories =
          body.map((dynamic item) => Category.fromJson(item)).toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // 🔹 (Old version) Fetch meals by category name
  Future<List<Meal>> getMealsByCategory(String categoryName) async {
    final url = Uri.parse('$_baseUrl/meals?strCategory=$categoryName');
    foundation.debugPrint('DEBUG (getMealsByCategory): Requesting URL: $url');

    final response = await http.get(
      url,
      headers: _headers,
    );

    foundation.debugPrint(
        'DEBUG (getMealsByCategory): Response Status Code: ${response.statusCode}');
    foundation.debugPrint(
        'DEBUG (getMealsByCategory): Response Body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Meal> meals =
          body.map((dynamic item) => Meal.fromJson(item)).toList();
      return meals;
    } else {
      throw Exception('Failed to load meals for category $categoryName');
    }
  }

  // ✅ NEW: Fetch meals by category ID (this is the one used in ExploreScreen)
  Future<List<Meal>> getMealsByCategoryId(String categoryId) async {
    final url = Uri.parse('$_baseUrl/meals?categoryId=$categoryId');
    foundation.debugPrint('DEBUG (getMealsByCategoryId): Requesting URL: $url');

    final response = await http.get(
      url,
      headers: _headers,
    );

    foundation.debugPrint(
        'DEBUG (getMealsByCategoryId): Response Status Code: ${response.statusCode}');
    foundation.debugPrint(
        'DEBUG (getMealsByCategoryId): Response Body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Meal> meals =
          body.map((dynamic item) => Meal.fromJson(item)).toList();
      return meals;
    } else {
      throw Exception('Failed to load meals for categoryId $categoryId');
    }
  }

  // 🔹 Fetch detail for one meal by ID
  Future<Meal> getMealDetail(String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/meals/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return Meal.fromJson(body);
    } else {
      throw Exception('Failed to load meal detail for ID: $id');
    }
  }
}
