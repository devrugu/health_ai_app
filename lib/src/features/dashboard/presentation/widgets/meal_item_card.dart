// lib/src/features/dashboard/presentation/widgets/meal_item_card.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/dashboard/domain/meal_plan_models.dart';

class MealItemCard extends StatefulWidget {
  final Meal meal;
  final bool isEaten;
  final VoidCallback onLogMeal;

  const MealItemCard({
    super.key,
    required this.meal,
    required this.isEaten,
    required this.onLogMeal,
  });

  @override
  State<MealItemCard> createState() => _MealItemCardState();
}

class _MealItemCardState extends State<MealItemCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEaten = widget.isEaten;
    // FIX: Use withAlpha
    final contentColor = isEaten
        ? theme.colorScheme.onSurface.withAlpha(128) // approx 0.5 opacity
        : theme.colorScheme.onSurface;

    return Card(
      // FIX: Use surfaceContainerHighest and withAlpha
      color: isEaten
          ? theme.colorScheme.surfaceContainerHighest
              .withAlpha(51) // approx 0.2 opacity
          : theme.colorScheme.surfaceContainerHighest
              .withAlpha(128), // approx 0.5 opacity
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            leading: Icon(widget.meal.icon, color: contentColor),
            title: Text(
              widget.meal.name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: contentColor,
                decoration:
                    isEaten ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            subtitle: Text(
              '${widget.meal.totalCalories} kcal • ${widget.meal.totalProtein}g Protein',
              style: theme.textTheme.bodyMedium?.copyWith(
                // FIX: Use withAlpha
                color: contentColor.withAlpha(204), // approx 0.8 opacity
                decoration:
                    isEaten ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLogButton(),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.expand_more),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Column(
                    children: [
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      ...widget.meal.items.map(
                          (foodItem) => _buildFoodListItem(foodItem, context)),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogButton() {
    return TextButton(
      onPressed: widget.onLogMeal,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: widget.isEaten
            ? const Row(children: [
                Text('Logged'),
                SizedBox(width: 4),
                Icon(Icons.check, size: 18)
              ])
            : const Row(children: [
                Text('Log'),
                SizedBox(width: 4),
                Icon(Icons.add_task, size: 18)
              ]),
      ),
    );
  }

  Widget _buildFoodListItem(FoodItem foodItem, BuildContext context) {
    final theme = Theme.of(context);
    final isEaten = widget.isEaten;
    // FIX: Use withAlpha
    final contentColor = isEaten
        ? theme.colorScheme.onSurface.withAlpha(128) // approx 0.5 opacity
        : theme.colorScheme.onSurface;

    return ListTile(
      dense: true,
      leading: const Icon(Icons.fiber_manual_record, size: 12),
      title: Text(
        foodItem.name,
        style: TextStyle(
          decoration:
              isEaten ? TextDecoration.lineThrough : TextDecoration.none,
          color: contentColor,
        ),
      ),
      subtitle: Text(
        foodItem.quantity,
        style: TextStyle(
          decoration:
              isEaten ? TextDecoration.lineThrough : TextDecoration.none,
          // FIX: Use withAlpha
          color: contentColor.withAlpha(204), // approx 0.8 opacity
        ),
      ),
      trailing: Text(
        '${foodItem.calories} kcal',
        style: TextStyle(
            decoration:
                isEaten ? TextDecoration.lineThrough : TextDecoration.none,
            color: contentColor,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
