// lib/models/meal.dart

class Meal {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> measures;

  Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.imageUrl,
    required this.ingredients,
    required this.measures,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    // Parse ingredients from the 'ingredients' array
    if (json['ingredients'] != null) {
      for (var item in (json['ingredients'] as List)) {
        if (item['ingredient'] != null && item['ingredient'].isNotEmpty) {
          ingredients.add(item['ingredient']);
          measures.add(item['measure'] ?? '');
        }
      }
    }

    return Meal(
      id: json['id'] ?? '',
      name: json['meal'] ?? '',
      category: json['category'] ?? '',
      area: json['area'] ?? '',
      instructions: json['instructions'] ?? '',
      imageUrl: json['mealThumb'] ?? '',
      ingredients: ingredients,
      measures: measures,
    );
  }
}