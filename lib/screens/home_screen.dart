// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';
import '../widgets/meal_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Meal?>? _randomMealFuture;
  // This helps ensure we only fetch data once when the screen is first built.
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to safely call the provider after the build is complete.
    // listen: false is important because we are in initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MealProvider>(context, listen: false).fetchMeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Finder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () {
              setState(() {
                _randomMealFuture = Provider.of<MealProvider>(context, listen: false).fetchRandomMeal();
              });
            },
          ),
        ],
      ),
      // Use a Consumer widget to listen for changes in the MealProvider
      body: _randomMealFuture == null
          ? Consumer<MealProvider>(
              builder: (context, mealProvider, child) {
                // If data is loading, show a progress indicator
                if (mealProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // If there are no meals, show a message
                if (mealProvider.meals.isEmpty) {
                  return const Center(child: Text('No meals found.'));
                }

                // Otherwise, display the list of meals
                return ListView.builder(
                  itemCount: mealProvider.meals.length,
                  itemBuilder: (context, index) {
                    final meal = mealProvider.meals[index];
                    return MealListItem(meal: meal);
                  },
                );
              },
            )
          : FutureBuilder<Meal?>(
              future: _randomMealFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('Failed to load random meal.'));
                }

                final meal = snapshot.data!;
                return MealDetailScreen(meal: meal);
              },
            ),
    );
  }
}

class MealDetailScreen extends StatelessWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
      ),
      body: Center(
        child: Text('Details for ${meal.name}'),
      ),
    );
  }
}
