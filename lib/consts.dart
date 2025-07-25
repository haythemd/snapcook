import 'package:flutter/material.dart';

Map<String, List<String>> userPreferences = {
  'dietary_preferences': [],
  'health_nutrition_goals': [],
  'time_to_cook': [],
  'budget_per_meal': [],
  'available_appliances': [],
  'household_size': [],
  'cuisine_preferences': [],
  'taste_profile': [],
  'preferred_meal_types': [],
};


final Map<String, Map<String, dynamic>> preferencesData = {
  'welcome': {
    'title': 'Welcome!',
    'subtitle': 'Let\'s personalize your cooking experience',
    'icon': Icons.waving_hand,
    'color': Colors.orange,
  },
  'dietary_preferences': {
    'title': 'Dietary Preferences',
    'subtitle': 'Select all that apply to you',
    'icon': Icons.restaurant_menu,
    'color': Colors.green,
    'options': [
      {'name': 'Vegetarian', 'icon': Icons.eco},
      {'name': 'Vegan', 'icon': Icons.nature},
      {'name': 'Pescatarian', 'icon': Icons.set_meal},
      {'name': 'Keto', 'icon': Icons.fitness_center},
      {'name': 'Paleo', 'icon': Icons.park},
      {'name': 'Halal', 'icon': Icons.verified},
      {'name': 'Kosher', 'icon': Icons.star},
      {'name': 'Gluten-Free', 'icon': Icons.no_food},
      {'name': 'Dairy-Free', 'icon': Icons.block},
      {'name': 'Nut-Free', 'icon': Icons.cancel},
      {'name': 'Egg-Free', 'icon': Icons.remove_circle},
      {'name': 'Low FODMAP', 'icon': Icons.health_and_safety},
    ],
  },
  'health_nutrition_goals': {
    'title': 'Health & Nutrition Goals',
    'subtitle': 'What are your main health objectives?',
    'icon': Icons.favorite,
    'color': Colors.red,
    'options': [
      {'name': 'Weight Loss', 'icon': Icons.trending_down},
      {'name': 'Muscle Gain', 'icon': Icons.fitness_center},
      {'name': 'Balanced Diet', 'icon': Icons.balance},
      {'name': 'Low Carb', 'icon': Icons.grain},
      {'name': 'High Protein', 'icon': Icons.sports_gymnastics},
      {'name': 'Intermittent Fasting', 'icon': Icons.schedule},
      {'name': 'Blood Sugar Control', 'icon': Icons.monitor_heart},
      {'name': 'Heart Health', 'icon': Icons.favorite_border},
      {'name': 'Just Eat Better', 'icon': Icons.thumb_up},
    ],
  },
  'time_to_cook': {
    'title': 'Time to Cook',
    'subtitle': 'How much time do you usually have?',
    'icon': Icons.timer,
    'color': Colors.blue,
    'singleSelect': true,
    'options': [
      {'name': '5–10 minutes (Express)', 'icon': Icons.flash_on},
      {'name': '10–20 minutes (Quick)', 'icon': Icons.speed},
      {'name': '20–30 minutes (Standard)', 'icon': Icons.access_time},
      {'name': '30–45 minutes (Gourmet)', 'icon': Icons.restaurant},
      {'name': '45+ minutes (Special Occasion)', 'icon': Icons.celebration},
    ],
  },
  'budget_per_meal': {
    'title': 'Budget per Meal',
    'subtitle': 'What\'s your typical meal budget?',
    'icon': Icons.attach_money,
    'color': Colors.amber,
    'singleSelect': true,
    'options': [
      {'name': 'Budget (\$) – under \$3', 'icon': Icons.money_off},
      {'name': 'Affordable (\$\$) – \$3 to \$7', 'icon': Icons.monetization_on},
      {'name': 'Premium (\$\$\$) – \$7 to \$15', 'icon': Icons.diamond},
      {'name': 'No Budget Limit', 'icon': Icons.all_inclusive},
    ],
  },
  'available_appliances': {
    'title': 'Available Appliances',
    'subtitle': 'What kitchen appliances do you have?',
    'icon': Icons.kitchen,
    'color': Colors.purple,
    'options': [
      {'name': 'Stove', 'icon': Icons.local_fire_department},
      {'name': 'Oven', 'icon': Icons.bakery_dining_outlined},
      {'name': 'Microwave', 'icon': Icons.microwave},
      {'name': 'Air Fryer', 'icon': Icons.air},
      {'name': 'Pressure Cooker', 'icon': Icons.soup_kitchen},
      {'name': 'Blender', 'icon': Icons.blender},
      {'name': 'Toaster', 'icon': Icons.breakfast_dining},
    ],
  },
  'household_size': {
    'title': 'Household Size',
    'subtitle': 'How many people are you cooking for?',
    'icon': Icons.people,
    'color': Colors.indigo,
    'singleSelect': true,
    'options': [
      {'name': 'Just Me', 'icon': Icons.person},
      {'name': '2 People', 'icon': Icons.people},
      {'name': '3–4 People', 'icon': Icons.group},
      {'name': '5+ People', 'icon': Icons.groups},
    ],
  },
  'cuisine_preferences': {
    'title': 'Cuisine Preferences',
    'subtitle': 'Which cuisines do you enjoy?',
    'icon': Icons.public,
    'color': Colors.teal,
    'options': [
      {'name': 'Italian', 'icon': Icons.local_pizza},
      {'name': 'Indian', 'icon': Icons.rice_bowl},
      {'name': 'Mexican', 'icon': Icons.local_dining},
      {'name': 'Chinese', 'icon': Icons.ramen_dining},
      {'name': 'Japanese', 'icon': Icons.set_meal},
      {'name': 'Middle Eastern', 'icon': Icons.kebab_dining},
      {'name': 'Mediterranean', 'icon': Icons.restaurant},
      {'name': 'American', 'icon': Icons.lunch_dining},
      {'name': 'Thai', 'icon': Icons.rice_bowl},
      {'name': 'African', 'icon': Icons.dinner_dining},
      {'name': 'French', 'icon': Icons.wine_bar},
      {'name': 'Fusion / Experimental', 'icon': Icons.auto_fix_high},
    ],
  },
  'taste_profile': {
    'title': 'Taste Profile',
    'subtitle': 'What flavors do you prefer?',
    'icon': Icons.psychology,
    'color': Colors.pink,
    'options': [
      {'name': 'Spicy', 'icon': Icons.whatshot},
      {'name': 'Savory', 'icon': Icons.restaurant_menu},
      {'name': 'Sweet', 'icon': Icons.cake},
      {'name': 'Sour', 'icon': Icons.sentiment_neutral},
      {'name': 'Bitter', 'icon': Icons.coffee},
      {'name': 'Umami', 'icon': Icons.water_drop},
      {'name': 'Comfort Food', 'icon': Icons.home},
      {'name': 'Clean/Earthy', 'icon': Icons.nature_people},
      {'name': 'Fresh/Light', 'icon': Icons.air},
    ],
  },
  'preferred_meal_types': {
    'title': 'Preferred Meal Types',
    'subtitle': 'When do you like to cook and eat?',
    'icon': Icons.schedule,
    'color': Colors.deepOrange,
    'options': [
      {'name': 'Breakfast', 'icon': Icons.free_breakfast},
      {'name': 'Lunch', 'icon': Icons.lunch_dining},
      {'name': 'Dinner', 'icon': Icons.dinner_dining},
      {'name': 'Snack', 'icon': Icons.cookie},
      {'name': 'Dessert', 'icon': Icons.icecream},
      {'name': 'Brunch', 'icon': Icons.brunch_dining},
      {'name': 'Pre/Post Workout', 'icon': Icons.fitness_center},
      {'name': 'Quick Bite', 'icon': Icons.fastfood},
      {'name': 'Party / Group Dish', 'icon': Icons.celebration},
    ],
  },
  'complete': {
    'title': 'All Set!',
    'subtitle': 'Your personalized cooking experience is ready',
    'icon': Icons.check_circle,
    'color': Colors.green,
  },
};

final List<String> pageOrder = [
  'welcome',
  'dietary_preferences',
  'health_nutrition_goals',
  'time_to_cook',
  'budget_per_meal',
  'available_appliances',
  'household_size',
  'cuisine_preferences',
  'taste_profile',
  'preferred_meal_types',
  'complete'
];