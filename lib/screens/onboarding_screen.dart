

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
with TickerProviderStateMixin {
late AnimationController _animationController;
late Animation<double> _backlightAnimation;
PageController _pageController = PageController();

bool _showLogo = true;
bool _isOnboarded = false;
int _currentPage = 0;

// User preferences storage
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

// Preference options data
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

@override
void initState() {
  super.initState();
  _initializeAnimation();
  _checkOnboardingStatus();
}

void _initializeAnimation() {
  _animationController = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  );

  _backlightAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  ));

  _animationController.repeat(reverse: true);

  Future.delayed(const Duration(seconds: 3), () {
    if (mounted) {
      _animationController.stop();
      _proceedAfterAnimation();
    }
  });
}

Future<void> _checkOnboardingStatus() async {
  final prefs = await SharedPreferences.getInstance();
  _isOnboarded = prefs.getBool('isOnboarded') ?? false;
}

void _proceedAfterAnimation() async {
  await _checkOnboardingStatus();

  if (_isOnboarded) {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  } else {
    setState(() {
      _showLogo = false;
    });
  }
}

void _togglePreference(String category, String preference) {
  setState(() {
    final categoryData = preferencesData[category];
    final isSingleSelect = categoryData?['singleSelect'] == true;

    if (isSingleSelect) {
      userPreferences[category] = [preference];
    } else {
      if (userPreferences[category]!.contains(preference)) {
        userPreferences[category]!.remove(preference);
      } else {
        userPreferences[category]!.add(preference);
      }
    }
  });
}

void _nextPage() {
  if (_currentPage < pageOrder.length - 1) {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  } else {
    _finishOnboarding();
  }
}

void _previousPage() {
  if (_currentPage > 0) {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

bool _canProceed() {
  final currentPageKey = pageOrder[_currentPage];
  if (currentPageKey == 'welcome' || currentPageKey == 'complete') {
    return true;
  }

  final categoryData = preferencesData[currentPageKey];
  final isSingleSelect = categoryData?['singleSelect'] == true;

  if (isSingleSelect) {
    return userPreferences[currentPageKey]!.isNotEmpty;
  }

  return true; // For multi-select, allow proceeding even with no selections
}

Future<void> _finishOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isOnboarded', true);

  // Save all preferences as StringLists
  for (String category in userPreferences.keys) {
    await prefs.setStringList(category, userPreferences[category]!);
  }

  if (mounted) {
    Navigator.pushReplacementNamed(context, '/');
  }
}

Widget _buildLogoScreen() {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: AnimatedBuilder(
        animation: _backlightAnimation,
        builder: (context, child) {
          return Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(_backlightAnimation.value * 0.8),
                  blurRadius: 50 * _backlightAnimation.value,
                  spreadRadius: 20 * _backlightAnimation.value,
                ),
              ],
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.restaurant_menu,
                size: 80,
                color: Colors.blue,
              ),
            ),
          );
        },
      ),
    ),
  );
}

Widget _buildWelcomePage() {
  final data = preferencesData['welcome']!;
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          data['icon'] as IconData,
          size: 80,
          color: data['color'] as Color,
        ),
        const SizedBox(height: 32),
        Text(
          data['title'] as String,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          data['subtitle'] as String,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildPreferencePage(String category) {
  final data = preferencesData[category]!;
  final options = data['options'] as List<Map<String, dynamic>>;
  final isSingleSelect = data['singleSelect'] == true;
  final selectedPreferences = userPreferences[category]!;

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        Row(
          children: [
            Icon(
              data['icon'] as IconData,
              color: data['color'] as Color,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'] as String,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${data['subtitle']} ${isSingleSelect ? '(Select one)' : '(Select all that apply)'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: options.length > 8 ? 3 : 2,
              childAspectRatio: options.length > 8 ? 1.0 : 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = selectedPreferences.contains(option['name']);

              return GestureDetector(
                onTap: () => _togglePreference(category, option['name']),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? (data['color'] as Color) : Colors.grey[300]!,
                      width: 2,
                    ),
                    color: isSelected
                        ? (data['color'] as Color).withOpacity(0.1)
                        : Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          option['icon'] as IconData,
                          size: options.length > 8 ? 24 : 32,
                          color: isSelected
                              ? (data['color'] as Color)
                              : Colors.grey[600],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          option['name'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: options.length > 8 ? 11 : 12,
                            color: isSelected
                                ? (data['color'] as Color)
                                : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget _buildCompletePage() {
  final data = preferencesData['complete']!;
  int totalSelections = userPreferences.values
      .fold(0, (sum, list) => sum + list.length);

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          data['icon'] as IconData,
          size: 80,
          color: data['color'] as Color,
        ),
        const SizedBox(height: 32),
        Text(
          data['title'] as String,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          data['subtitle'] as String,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'You\'ve made $totalSelections preferences selections!\nWe\'ll use these to personalize your experience.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

@override
Widget build(BuildContext context) {
  if (_showLogo) {
    return _buildLogoScreen();
  }

  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: pageOrder.length,
              itemBuilder: (context, index) {
                final pageKey = pageOrder[index];

                if (pageKey == 'welcome') {
                  return _buildWelcomePage();
                } else if (pageKey == 'complete') {
                  return _buildCompletePage();
                } else {
                  return _buildPreferencePage(pageKey);
                }
              },
            ),
          ),
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pageOrder.length,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: _currentPage == index ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Navigation buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  TextButton(
                    onPressed: _previousPage,
                    child: const Text('Back'),
                  )
                else
                  const SizedBox.shrink(),
                ElevatedButton(
                  onPressed: _canProceed() ? _nextPage : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: Text(_currentPage == pageOrder.length - 1 ? 'Get Started' : 'Next'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

@override
void dispose() {
  _animationController.dispose();
  _pageController.dispose();
  super.dispose();
}
}