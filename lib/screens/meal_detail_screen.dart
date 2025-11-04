// lib/screens/meal_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';

class MealDetailScreen extends StatelessWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Consumer<MealProvider>(
      builder: (context, mealProvider, child) {
        final isFavorite = mealProvider.isFavorite(meal);
        return Scaffold(
          appBar: AppBar(
            title: Text(meal.name),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  mealProvider.toggleFavorite(meal);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                  meal.imageUrl,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ingredients',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      // Build the ingredients list
                      _buildIngredientsList(),
                      const SizedBox(height: 20),
                      const Text(
                        'Instructions',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        meal.instructions,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // A helper widget to build the ingredients list
  Widget _buildIngredientsList() {
    return ListView.builder(
      // Important: These two lines prevent the ListView from scrolling
      // inside the SingleChildScrollView and make it take up only the space it needs.
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: meal.ingredients.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            '• ${meal.measures[index]} ${meal.ingredients[index]}',
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }
}