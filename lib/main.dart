
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_finder_app/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/meal_provider.dart'; // Import the provider
import 'screens/main_screen.dart';
import 'providers/category_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;
  runApp(
    // Wrap the entire app in a MultiProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MealProvider()),
        // You can add more providers here later, e.g., for categories or favorites
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: RecipeFinderApp(showOnboarding: showOnboarding),
    ),
  );
}

class RecipeFinderApp extends StatelessWidget {
  final bool showOnboarding;
  const RecipeFinderApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Changed theme for a new look
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Set the home property to our new MainScreen
      home: showOnboarding ? const OnboardingScreen() : const MainScreen(),
    );
  }
}
