// lib/src/features/dashboard/domain/meal_plan_models.dart

// Represents a single food item in a meal
import 'package:flutter/material.dart';

class FoodItem {
  final String name;
  final String quantity; // e.g., "100g", "1 cup"
  final int calories;
  final int protein;

  FoodItem({
    required this.name,
    required this.quantity,
    required this.calories,
    required this.protein,
  });
}

// Represents a complete meal (e.g., Breakfast)
class Meal {
  final String name;
  final IconData icon; // An icon to represent the meal
  final List<FoodItem> items;
  int get totalCalories => items.fold(0, (sum, item) => sum + item.calories);
  int get totalProtein => items.fold(0, (sum, item) => sum + item.protein);

  Meal({
    required this.name,
    required this.icon,
    required this.items,
  });
}
