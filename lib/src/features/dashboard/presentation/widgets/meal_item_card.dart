// lib/src/features/dashboard/presentation/widgets/meal_item_card.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/dashboard/domain/meal_plan_models.dart';

// We convert this to a StatefulWidget to manage its own expand/collapse state.
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
  // State variable to track if the card is expanded.
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEaten = widget.isEaten; // Access properties via widget.
    final contentColor = isEaten
        ? theme.colorScheme.onSurface.withOpacity(0.5)
        : theme.colorScheme.onSurface;

    return Card(
      color: isEaten
          ? theme.colorScheme.surfaceVariant.withOpacity(0.2)
          : theme.colorScheme.surfaceVariant.withOpacity(0.5),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // We use clipBehavior to ensure the inner content respects the card's rounded corners.
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // This ListTile acts as the clickable header of the card.
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
                color: contentColor.withOpacity(0.8),
                decoration:
                    isEaten ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            // The trailing part contains the log button AND the expand icon.
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLogButton(),
                // An animated icon that rotates when the card is expanded.
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0, // 0.5 turns = 180 degrees
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.expand_more),
                ),
              ],
            ),
          ),
          // This widget smoothly animates its size when its child's visibility changes.
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              // Only build the children list if the card is expanded.
              child: _isExpanded
                  ? Column(
                      children: [
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ...widget.meal.items
                            .map((foodItem) =>
                                _buildFoodListItem(foodItem, context))
                            .toList(),
                      ],
                    )
                  : const SizedBox
                      .shrink(), // Otherwise, build an empty, zero-sized box.
            ),
          ),
        ],
      ),
    );
  }

  // The button for logging a meal (no changes here)
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

  // A styled list item for each food within the meal (no changes here)
  Widget _buildFoodListItem(FoodItem foodItem, BuildContext context) {
    final theme = Theme.of(context);
    final isEaten = widget.isEaten;
    final contentColor = isEaten
        ? theme.colorScheme.onSurface.withOpacity(0.5)
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
          color: contentColor.withOpacity(0.8),
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
