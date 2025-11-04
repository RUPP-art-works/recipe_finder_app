// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/meal_provider.dart'; // Import the provider
import 'screens/main_screen.dart';
import 'providers/category_provider.dart';

void main() {

  runApp(
    // Wrap the entire app in a MultiProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MealProvider()),
        // You can add more providers here later, e.g., for categories or favorites
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: const RecipeFinderApp(),
    ),
  );
}

class RecipeFinderApp extends StatelessWidget {
  const RecipeFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Finder',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Changed theme for a new look
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Set the home property to our new MainScreen
      home: const MainScreen(),
    );
  }
}