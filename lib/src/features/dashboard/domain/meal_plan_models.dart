// lib/src/features/dashboard/domain/meal_plan_models.dart

import 'package:flutter/material.dart';

class FoodItem {
  final String name;
  final String quantity;
  final int calories;
  final int protein;

  FoodItem({
    required this.name,
    required this.quantity,
    required this.calories,
    required this.protein,
  });

  // NEW: Factory constructor to create a FoodItem from a map (like from Firestore)
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? '',
      calories: map['calories'] ?? 0,
      protein: map['protein'] ?? 0,
    );
  }
}

class Meal {
  final String name;
  final IconData icon;
  final List<FoodItem> items;
  int get totalCalories => items.fold(0, (sum, item) => sum + item.calories);
  int get totalProtein => items.fold(0, (sum, item) => sum + item.protein);

  Meal({
    required this.name,
    required this.icon,
    required this.items,
  });

  // NEW: Factory constructor to create a Meal from a map
  factory Meal.fromMap(Map<String, dynamic> map) {
    // Helper to parse the icon string from the AI into a real IconData object
    IconData parseIcon(String iconName) {
      switch (iconName) {
        case 'free_breakfast':
        case 'free_breakfast_rounded':
          return Icons.free_breakfast_rounded;
        case 'lunch_dining':
        case 'lunch_dining_rounded':
          return Icons.lunch_dining_rounded;
        case 'dinner_dining':
        case 'dinner_dining_rounded':
          return Icons.dinner_dining_rounded;
        default:
          return Icons.restaurant;
      }
    }

    // Convert the list of food item maps into a list of FoodItem objects
    var itemsList = (map['items'] as List<dynamic>?)
            ?.map((itemMap) => FoodItem.fromMap(itemMap))
            .toList() ??
        [];

    return Meal(
      name: map['name'] ?? '',
      icon: parseIcon(map['icon'] ?? ''),
      items: itemsList,
    );
  }
}

// NEW: A class to hold the entire daily plan from the AI
class TodaysPlan {
  final int dailyCalorieTarget;
  final int dailyProteinTarget;
  final int dailyCarbsTarget;
  final int dailyFatTarget;
  final int dailyWaterTargetMl;
  final List<Meal> initialMealPlan;

  TodaysPlan({
    required this.dailyCalorieTarget,
    required this.dailyProteinTarget,
    required this.dailyCarbsTarget,
    required this.dailyFatTarget,
    required this.dailyWaterTargetMl,
    required this.initialMealPlan,
  });

  factory TodaysPlan.fromMap(Map<String, dynamic> map) {
    var mealPlanList = (map['initialMealPlan'] as List<dynamic>?)
            ?.map((mealMap) => Meal.fromMap(mealMap))
            .toList() ??
        [];

    return TodaysPlan(
      dailyCalorieTarget: map['dailyCalorieTarget'] ?? 2000,
      dailyProteinTarget: map['dailyProteinTarget'] ?? 150,
      dailyCarbsTarget: map['dailyCarbsTarget'] ?? 200,
      dailyFatTarget: map['dailyFatTarget'] ?? 60,
      dailyWaterTargetMl: map['dailyWaterTargetMl'] ?? 2500,
      initialMealPlan: mealPlanList,
    );
  }
}
