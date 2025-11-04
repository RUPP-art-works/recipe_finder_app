// lib/screens/explore_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/category_provider.dart';
import '../api/api_service.dart'; // We need this for fetching filtered meals
import '../widgets/meal_list_item.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ApiService _apiService = ApiService();
  List<Meal> _filteredMeals = [];
  bool _isMealsLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch categories when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  // Method to fetch meals based on the selected category
  Future<void> _fetchMealsForCategory(String? categoryName) async {
    debugPrint('Fetching meals for category: $categoryName');
    if (categoryName == null) {
      setState(() {
        _filteredMeals = []; // Clear the list if no category is selected
      });
      return;
    }

    setState(() {
      _isMealsLoading = true;
    });

    try {
      final meals = await _apiService.getMealsByCategory(categoryName);
      setState(() {
        _filteredMeals = meals;
        debugPrint('Found ${_filteredMeals.length} meals.');
      });
    } catch (e) {
      debugPrint(e.toString());
      // Optionally, show a snackbar or error message
    } finally {
      setState(() {
        _isMealsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore by Category'),
      ),
      body: Column(
        children: [
          // 1. Category Filter Chips
          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
              if (categoryProvider.isLoading) {
                return const Center(child: LinearProgressIndicator());
              }
              return SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryProvider.categories[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: FilterChip(
                        avatar: CircleAvatar(
                          backgroundImage: NetworkImage(category.thumbnailUrl),
                        ),
                        label: Text(category.name),
                        selected:
                            categoryProvider.selectedCategory == category.name,
                        onSelected: (isSelected) {
                          // Update the selected category in the provider
                          categoryProvider.selectCategory(category.name);
                          debugPrint('Selected category from provider: ${categoryProvider.selectedCategory}');
                          // Fetch meals for the newly selected category
                          _fetchMealsForCategory(
                              categoryProvider.selectedCategory);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const Divider(),
          // 2. Filtered Meal List
          Expanded(
            child: _isMealsLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredMeals.isEmpty
                    ? const Center(
                        child: Text('Select a category to see meals.'))
                    : ListView.builder(
                        itemCount: _filteredMeals.length,
                        itemBuilder: (context, index) {
                          final meal = _filteredMeals[index];
                          return MealListItem(meal: meal);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
