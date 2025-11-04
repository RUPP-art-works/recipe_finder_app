// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';
import '../widgets/meal_list_item.dart';
import '../widgets/popular_meal_banner.dart';
import 'meal_detail_screen.dart';

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
      body: Column(
        children: [
          if (_randomMealFuture ==
              null) // Only show popular banner initially
            const PopularMealBanner(),
          Expanded(
            child: _randomMealFuture == null
                ? Consumer<MealProvider>(
                    builder: (context, mealProvider, child) {
                      if (mealProvider.isLoading) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      if (mealProvider.meals.isEmpty) {
                        return const Center(
                            child: Text('No meals found.'));
                      }

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
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data == null) {
                        return const Center(
                            child: Text('Failed to load random meal.'));
                      }

                      final meal = snapshot.data!;
                      return MealDetailScreen(meal: meal);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
