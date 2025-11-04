// lib/screens/favorite_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import '../widgets/meal_list_item.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Consumer<MealProvider>(
        builder: (context, mealProvider, child) {
          final favoriteMeals = mealProvider.favoriteMeals;

          if (favoriteMeals.isEmpty) {
            return const Center(
              child: Text(
                'No favorite meals yet. Start adding some!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: favoriteMeals.length,
              itemBuilder: (context, index) {
                return MealListItem(meal: favoriteMeals[index]);
              },
            );
          }
        },
      ),
    );
  }
}