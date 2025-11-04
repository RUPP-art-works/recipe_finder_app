import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';
import '../providers/category_provider.dart';
import '../widgets/meal_list_item.dart';
import '../widgets/popular_meal_banner.dart';
import 'meal_detail_screen.dart';
import 'category_meals_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Meal?>? _randomMealFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MealProvider>(context, listen: false).fetchMeals();
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          '🍽️ Recipe Finder',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Shuffle a random meal',
            icon: const Icon(Icons.shuffle_rounded, size: 26),
            onPressed: () {
              setState(() {
                _randomMealFuture = Provider.of<MealProvider>(
                  context,
                  listen: false,
                ).fetchRandomMeal();
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9F9F9), Color(0xFFF0F4F8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: _randomMealFuture == null
              ? Consumer<MealProvider>(
                  builder: (context, mealProvider, _) {
                    if (mealProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (mealProvider.meals.isEmpty) {
                      return const Center(child: Text('No meals found 😢'));
                    }

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: PopularMealBanner(),
                            ),
                            const SizedBox(height: 20),
                            _buildCategorySection(context),
                            const SizedBox(height: 20),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '✨ Random Food Suggestions',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Wrap the grid in a container with shrinkWrap
                            GridView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(), // important
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.85,
                              ),
                              itemCount: mealProvider.meals.length,
                              itemBuilder: (context, index) {
                                final meal = mealProvider.meals[index];
                                return MealListItem(meal: meal);
                              },
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : FutureBuilder<Meal?>(
                  future: _randomMealFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data == null) {
                      return const Center(
                        child: Text('Failed to load random meal.'),
                      );
                    }

                    final meal = snapshot.data!;
                    return MealDetailScreen(meal: meal);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Consumer<CategoryProvider>(
          builder: (context, categoryProvider, _) {
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
                      onSelected: (isSelected) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CategoryMealsScreen(categoryName: category.name),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

}
