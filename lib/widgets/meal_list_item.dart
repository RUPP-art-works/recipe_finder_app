import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../screens/meal_detail_screen.dart';

class MealListItem extends StatelessWidget {
  final Meal meal;

  const MealListItem({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailScreen(meal: meal),
          ),
        );
      },
      child: Hero(
        tag: meal.id ?? meal.name, // for nice transition
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
          shadowColor: Colors.black26,
          clipBehavior: Clip.hardEdge,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Image.network(
                  meal.imageUrl,
                  key: ValueKey(meal.imageUrl),
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child:
                        Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  meal.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 4,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 20,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
