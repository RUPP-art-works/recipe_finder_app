// lib/widgets/meal_list_item.dart

import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../screens/meal_detail_screen.dart'; // Import the detail screen

class MealListItem extends StatelessWidget {
  final Meal meal;

  const MealListItem({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    // InkWell makes the widget tappable and provides a visual ripple effect.
    return InkWell(
      onTap: () {
        // This is the navigation logic.
        // It pushes a new screen (MealDetailScreen) onto the navigation stack.
        Navigator.push(
          context,
          MaterialPageRoute(
            // We pass the specific 'meal' for this list item to the detail screen.
            builder: (context) => MealDetailScreen(meal: meal),
          ),
        );
      },
      // The child of the InkWell is the visual representation of the list item.
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image with rounded corners at the top
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                meal.imageUrl,
                height: 200,
                fit: BoxFit.cover,
                // Show a loading indicator while the image is loading
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                // Show an icon if the image fails to load
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 200,
                    child: Icon(Icons.broken_image, size: 50),
                  );
                },
              ),
            ),
            // Meal details below the image
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Category: ${meal.category}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
