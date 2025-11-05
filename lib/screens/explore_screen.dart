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
  bool _isMealsLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch categories when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  // ✅ Fetch meals based on categoryId
  Future<void> _fetchMealsForCategoryId(String? categoryId) async {
    debugPrint('Fetching meals for categoryId: $categoryId');

    if (categoryId == null || categoryId.isEmpty) {
      setState(() => _filteredMeals = []);
      return;
    }

    setState(() => _isMealsLoading = true);

    try {
      final meals = await _apiService.getMealsByCategoryId(categoryId);
      setState(() {
        _filteredMeals = meals;
        debugPrint(
            'Found ${_filteredMeals.length} meals for category $categoryId.');
      });
    } catch (e) {
      debugPrint('Error fetching meals: $e');
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
        title: const Text('Explore by Category'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔹 Category Filter Chips
          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, _) {
              if (categoryProvider.isLoading) {
                return const Center(child: LinearProgressIndicator());
              }

              if (categoryProvider.categories.isEmpty) {
                return const Center(child: Text('No categories found.'));
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
                          // ✅ Update selected category
                          categoryProvider.selectCategory(category.name);
                          debugPrint(
                              'Selected: ${category.name} (id: ${category.id})');

                          // ✅ Fetch by categoryId (the real filter key)
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

          // 🔹 Filtered Meal List
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
