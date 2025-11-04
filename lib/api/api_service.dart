import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../models/category.dart';

class ApiService {
  final String _baseUrl = 'https://meal-db-sandy.vercel.app';

  // IMPORTANT: Make sure this GUID is exactly the one that works in Postman.
  final Map<String, String> _headers = {
    'X-DB-NAME':
        'e5c213ef-7c04-4961-a5da-12a3667228b4' // <-- PASTE YOUR GUID HERE
  };

  Future<List<Meal>> getMeals() async {
    // We are making a request to the /meals endpoint
    final response = await http.get(
      Uri.parse('$_baseUrl/meals'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      List<dynamic> body = jsonDecode(response.body);
      List<Meal> meals =
          body.map((dynamic item) => Meal.fromJson(item)).toList();
      return meals;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load meals');
    }
  }

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

  Future<List<Category>> getCategories() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/categories'),
      headers: _headers,
    );

    // Optional: You can add debug prints here too if needed
    // print('DEBUG (getCategories): Response Status Code: ${response.statusCode}');
    // print('DEBUG (getCategories): Response Body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Category> categories =
          body.map((dynamic item) => Category.fromJson(item)).toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Meal>> getMealsByCategory(String categoryName) async {
    // The API uses a query parameter to filter, e.g., /meals?strCategory=Seafood
    final response = await http.get(
      Uri.parse('$_baseUrl/meals?strCategory=$categoryName'),
      headers: _headers,
    );

    // Optional: You can add debug prints here too if needed
    // print('DEBUG (getMealsByCategory): Response Status Code: ${response.statusCode}');
    // print('DEBUG (getMealsByCategory): Response Body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Meal> meals =
          body.map((dynamic item) => Meal.fromJson(item)).toList();
      return meals;
    } else {
      throw Exception('Failed to load meals for category $categoryName');
    }
  }

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

