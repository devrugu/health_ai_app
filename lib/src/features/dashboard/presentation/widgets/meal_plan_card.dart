// lib/src/features/dashboard/presentation/widgets/meal_plan_card.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/dashboard/domain/meal_plan_models.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/meal_item_card.dart';

class MealPlanCard extends StatefulWidget {
  const MealPlanCard({super.key});

  @override
  State<MealPlanCard> createState() => _MealPlanCardState();
}

class _MealPlanCardState extends State<MealPlanCard> {
  late final List<Meal> _meals;
  final Set<String> _eatenMeals = {};

  @override
  void initState() {
    super.initState();
    _meals = _getSampleMeals();
  }

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Meals",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // --- THIS IS THE FIX ---
        // We replace the problematic ListView.builder with a Column.
        // The '.map()' function iterates through our meals and creates a list of widgets.
        // The spread operator '...' inserts these widgets individually into the Column's children.
        Column(
          children: _meals.map((meal) {
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

  // --- SAMPLE DATA (No changes here) ---
  List<Meal> _getSampleMeals() {
    return [
      Meal(
        name: 'Breakfast',
        icon: Icons.free_breakfast_rounded,
        items: [
          FoodItem(
              name: 'Oatmeal', quantity: '1 cup', calories: 300, protein: 10),
          FoodItem(
              name: 'Blueberries',
              quantity: '1/2 cup',
              calories: 40,
              protein: 1),
          FoodItem(
              name: 'Almonds', quantity: '1/4 cup', calories: 200, protein: 8),
        ],
      ),
      Meal(
        name: 'Lunch',
        icon: Icons.lunch_dining_rounded,
        items: [
          FoodItem(
              name: 'Grilled Chicken Breast',
              quantity: '150g',
              calories: 250,
              protein: 45),
          FoodItem(
              name: 'Quinoa', quantity: '1 cup', calories: 220, protein: 8),
          FoodItem(
              name: 'Broccoli', quantity: '1 cup', calories: 55, protein: 4),
        ],
      ),
      Meal(
        name: 'Dinner',
        icon: Icons.dinner_dining_rounded,
        items: [
          FoodItem(
              name: 'Salmon Fillet',
              quantity: '150g',
              calories: 300,
              protein: 40),
          FoodItem(
              name: 'Sweet Potato',
              quantity: '1 medium',
              calories: 180,
              protein: 4),
          FoodItem(
              name: 'Asparagus', quantity: '1 cup', calories: 40, protein: 4),
        ],
      ),
    ];
  }
}
