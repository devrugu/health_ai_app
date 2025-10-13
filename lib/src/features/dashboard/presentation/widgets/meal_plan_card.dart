// lib/src/features/dashboard/presentation/widgets/meal_plan_card.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/dashboard/domain/meal_plan_models.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/meal_item_card.dart';

class MealPlanCard extends StatefulWidget {
  // NEW: Add a parameter for the meal plan
  final List<Meal> meals;

  const MealPlanCard({super.key, required this.meals});

  @override
  State<MealPlanCard> createState() => _MealPlanCardState();
}

class _MealPlanCardState extends State<MealPlanCard> {
  // REMOVED: The hardcoded list of meals is gone.
  final Set<String> _eatenMeals = {};

  // REMOVED: initState is no longer needed to create sample data.

  void _toggleMealEaten(String mealName) {
    setState(() {
      if (_eatenMeals.contains(mealName)) {
        _eatenMeals.remove(mealName);
      } else {
        _eatenMeals.add(mealName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // If for some reason the meal plan is empty, show a message.
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
          // UPDATED: Use widget.meals to generate the list of cards
          children: widget.meals.map((meal) {
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