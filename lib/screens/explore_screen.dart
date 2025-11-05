import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/category_provider.dart';
import '../api/api_service.dart';
import '../widgets/meal_list_item.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ApiService _apiService = ApiService();
  List<Meal> _filteredMeals = [];
  List<Meal> _randomMeals = [];
  bool _isMealsLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch categories and random meals when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      _fetchRandomMeals();
    });
  }

  Future<void> _fetchRandomMeals() async {
    setState(() => _isMealsLoading = true);
    try {
      final meals = await _apiService.getMultipleRandomMeals(6);
      setState(() => _randomMeals = meals);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load random meals.')),
      );
    } finally {
      setState(() => _isMealsLoading = false);
    }
  }

  Future<void> _fetchMealsForCategoryId(String? categoryId) async {
    if (categoryId == null || categoryId.isEmpty) {
      setState(() => _filteredMeals = []);
      return;
    }

    setState(() => _isMealsLoading = true);

    try {
      final meals = await _apiService.getMealsByCategoryId(categoryId);
      setState(() => _filteredMeals = meals);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load meals.')),
      );
    } finally {
      setState(() => _isMealsLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Recipes'),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Column(
        children: [
          // 1. Category Filter Chips
          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
              if (categoryProvider.isLoading) {
                return const LinearProgressIndicator();
              }
              return SizedBox(
                height: 60,
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
                          categoryProvider.selectCategory(category.name);
                          _fetchMealsForCategoryId(category.id);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const Divider(),

          // 2. Meals Grid
          Expanded(
            child: _isMealsLoading
                ? const Center(child: CircularProgressIndicator())
                : Builder(
                    builder: (context) {
                      final categoryProvider =
                          Provider.of<CategoryProvider>(context, listen: false);
                      final mealsToShow =
                          categoryProvider.selectedCategory == null
                              ? _randomMeals
                              : _filteredMeals;

                      if (mealsToShow.isEmpty) {
                        return const Center(
                          child: Text(
                            'No meals to display.',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        child: GridView.builder(
                          itemCount: mealsToShow.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                          itemBuilder: (context, index) {
                            return MealListItem(meal: mealsToShow[index]);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
