import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapcook/screens/auth_screen.dart';
import 'package:snapcook/screens/cooking_screen.dart';
import 'package:snapcook/screens/favorites_screen.dart';
import 'package:snapcook/screens/home_screen.dart';
import 'package:snapcook/screens/onboarding_screen.dart';
import 'package:snapcook/screens/profile_screen.dart';
import 'package:snapcook/screens/recipe/recipe_detail_screen.dart';
import 'package:snapcook/screens/recipe/recipes_screen.dart' hide Recipe;
import 'package:snapcook/screens/settings_screen.dart';

void main() {
  runApp( ProviderScope(child: MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapCook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (BuildContext context)=> HomeScreen(),
        '/onboarding': (BuildContext context)=> OnboardingScreen(),
        '/auth': (BuildContext context)=> AuthScreen(),
        '/recipes': (BuildContext context)=> RecipeListView(),
        '/recipe_details': (BuildContext context)=> RecipeSingleView(recipe: sampleRecipe),
        '/settings': (BuildContext context)=> SettingsScreen(),
        '/profile': (BuildContext context)=> ProfileScreen(),
        '/favorites': (BuildContext context)=> FavoritesScreen(),
        '/cooking': (BuildContext context)=> CookingScreen(),
      },
      initialRoute: '/onboarding',
    );
  }
}
final Recipe sampleRecipe = Recipe(
  name: "Spaghetti Carbonara",
  description: "A classic Italian pasta dish with eggs, cheese, pancetta, and pepper. This creamy and delicious comfort food is perfect for dinner and will transport you straight to Rome with every bite.",
  cookingTime: "25 min",
  difficulty: "Medium",
  ingredients: [
    "400g Spaghetti pasta",
    "200g Pancetta or guanciale, diced",
    "4 large eggs",
    "100g Parmesan cheese, grated",
    "2 cloves garlic, minced",
    "Fresh black pepper to taste",
    "Salt for pasta water",
    "2 tbsp olive oil"
  ],
  image: "https://images.unsplash.com/photo-1551892374-ecf8285cf834?w=400",
  steps: [
    "Bring a large pot of salted water to boil and cook spaghetti according to package directions until al dente.",
    "While pasta cooks, heat olive oil in a large skillet over medium heat. Add pancetta and cook until crispy, about 5-7 minutes.",
    "In a bowl, whisk together eggs, grated Parmesan, and a generous amount of black pepper.",
    "Reserve 1 cup of pasta cooking water, then drain the pasta.",
    "Add hot pasta to the skillet with pancetta and toss to combine.",
    "Remove from heat and quickly stir in the egg mixture, adding pasta water as needed to create a creamy sauce.",
    "Serve immediately with extra Parmesan and black pepper."
  ],
  categories: ["Italian", "Pasta", "Dinner", "Comfort Food"],
);
