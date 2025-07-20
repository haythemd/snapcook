import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapcook/screens/auth_screen.dart';
import 'package:snapcook/screens/cooking_screen.dart';
import 'package:snapcook/screens/favorites_screen.dart';
import 'package:snapcook/screens/home_screen.dart';
import 'package:snapcook/screens/onboarding_screen.dart';
import 'package:snapcook/screens/profile_screen.dart';
import 'package:snapcook/screens/recipe/recipe_detail_screen.dart';
import 'package:snapcook/screens/recipe/recipes_screen.dart';
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
        '/recipes': (BuildContext context)=> RecipesScreen(),
        '/recipe_details': (BuildContext context)=> RecipeDetailScreen(),
        '/settings': (BuildContext context)=> SettingsScreen(),
        '/profile': (BuildContext context)=> ProfileScreen(),
        '/favorites': (BuildContext context)=> FavoritesScreen(),
        '/cooking': (BuildContext context)=> CookingScreen(),
      },
      initialRoute: '/onboarding',
    );
  }
}

