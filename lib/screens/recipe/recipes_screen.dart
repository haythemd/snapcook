import 'package:flutter/material.dart';

// Recipe Model
class Recipe {
  final String name;
  final String description;
  final String cookingTime;
  final String difficulty;
  final List<String> ingredients;
  final String image;
  final List<String> steps;
  final List<String> categories;

  Recipe({
    required this.name,
    required this.description,
    required this.cookingTime,
    required this.difficulty,
    required this.ingredients,
    required this.image,
    required this.steps,
    required this.categories,
  });
}

// Recipe List View
class RecipeListView extends StatelessWidget {
   RecipeListView({Key? key}) : super(key: key);

  final List<Recipe> sampleRecipes = [
    Recipe(
      name: "Spaghetti Carbonara",
      description: "A classic Italian pasta dish with eggs, cheese, pancetta, and pepper. Creamy and delicious comfort food that's perfect for dinner.",
      cookingTime: "25 min",
      difficulty: "Medium",
      ingredients: ["Spaghetti", "Eggs", "Parmesan", "Pancetta", "Black Pepper"],
      image: "https://images.unsplash.com/photo-1551892374-ecf8285cf834?w=400",
      steps: ["Boil pasta", "Cook pancetta", "Mix eggs and cheese", "Combine all"],
      categories: ["Italian", "Pasta", "Dinner"],
    ),
    Recipe(
      name: "Avocado Toast",
      description: "Simple and healthy breakfast with smashed avocado, lime, and seasonings on toasted bread. Perfect start to your day.",
      cookingTime: "10 min",
      difficulty: "Easy",
      ingredients: ["Bread", "Avocado", "Lime", "Salt", "Pepper"],
      image: "https://images.unsplash.com/photo-1603046891726-36bdc85dfb93?w=400",
      steps: ["Toast bread", "Mash avocado", "Add seasonings", "Serve"],
      categories: ["Breakfast", "Healthy", "Quick"],
    ),
    Recipe(
      name: "Beef Wellington",
      description: "An elegant and sophisticated dish featuring tender beef wrapped in puff pastry. Perfect for special occasions and impressive dinner parties.",
      cookingTime: "2 hours",
      difficulty: "Hard",
      ingredients: ["Beef Tenderloin", "Puff Pastry", "Mushrooms", "Prosciutto", "Egg"],
      image: "https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400",
      steps: ["Sear beef", "Prepare mushroom duxelles", "Wrap in pastry", "Bake"],
      categories: ["Gourmet", "Beef", "Special"],
    ),
    Recipe(
      name: "Greek Salad",
      description: "Fresh and vibrant Mediterranean salad with tomatoes, cucumbers, olives, and feta cheese. Light and refreshing meal.",
      cookingTime: "15 min",
      difficulty: "Easy",
      ingredients: ["Tomatoes", "Cucumber", "Olives", "Feta", "Olive Oil"],
      image: "https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400",
      steps: ["Chop vegetables", "Add olives and feta", "Make dressing", "Toss and serve"],
      categories: ["Mediterranean", "Salad", "Healthy"],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Recipes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sampleRecipes.length,
        itemBuilder: (context, index) {
          return RecipeCard(recipe: sampleRecipes[index]);
        },
      ),
    );
  }
}

// Recipe Card Widget
class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section with Overlays
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Stack(
              children: [
                // Recipe Image
                Image.network(
                  recipe.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey[300]!, Colors.grey[400]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        size: 50,
                        color: Colors.white,
                      ),
                    );
                  },
                ),

                // Difficulty Badge (Top Left)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(recipe.difficulty).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      recipe.difficulty,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Cooking Time (Top Right)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recipe.cookingTime,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Categories (Bottom of Image)
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Wrap(
                    spacing: 6,
                    children: recipe.categories.take(3).map((category) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Recipe Info Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Name
                Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Recipe Description
                Text(
                  recipe.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Ingredients Count
                Row(
                  children: [
                    Icon(
                      Icons.list_alt,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${recipe.ingredients.length} ingredients',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}