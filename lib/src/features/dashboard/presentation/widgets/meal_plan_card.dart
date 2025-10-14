// lib/src/features/dashboard/presentation/widgets/meal_plan_card.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/database/data/database_service.dart'; // Import
import 'package:health_ai_app/src/features/dashboard/domain/meal_plan_models.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/meal_item_card.dart';

class MealPlanCard extends StatefulWidget {
  final List<Meal> meals;
  // NEW: Pass in the set of already eaten meals
  final Set<String> initialEatenMeals;

  const MealPlanCard({
    super.key,
    required this.meals,
    required this.initialEatenMeals,
  });

  @override
  State<MealPlanCard> createState() => _MealPlanCardState();
}

class _MealPlanCardState extends State<MealPlanCard> {
  // State is now initialized from the widget's parameters
  late Set<String> _eatenMeals;

  @override
  void initState() {
    super.initState();
    _eatenMeals = widget.initialEatenMeals;
  }

  void _toggleMealEaten(String mealName) {
    setState(() {
      if (_eatenMeals.contains(mealName)) {
        _eatenMeals.remove(mealName);
      } else {
        _eatenMeals.add(mealName);
      }
    });
    // Save the updated list to the database
    DatabaseService().updateDailyLog({'mealsEaten': _eatenMeals.toList()});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.meals.isEmpty) {
      return const Center(child: Text('No meal plan available for today.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Meals",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Column(
          children: widget.meals.map((meal) {
            // Use the state variable to check if a meal is eaten
            final isEaten = _eatenMeals.contains(meal.name);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: MealItemCard(
                meal: meal,
                isEaten: isEaten,
                onLogMeal: () => _toggleMealEaten(meal.name),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}