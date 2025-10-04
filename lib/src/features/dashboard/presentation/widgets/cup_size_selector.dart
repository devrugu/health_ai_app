// lib/src/features/dashboard/presentation/widgets/cup_size_selector.dart

import 'package:flutter/material.dart';

class CupSizeSelector extends StatelessWidget {
  final List<int> cupSizes;
  final int selectedSize;
  final Function(int) onSizeSelected;

  const CupSizeSelector({
    super.key,
    required this.cupSizes,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: cupSizes.map((size) {
        final isSelected = size == selectedSize;
        return ChoiceChip(
          label: Text('${size}ml'),
          selected: isSelected,
          onSelected: (_) => onSizeSelected(size),
          // Style for a more modern, integrated look
          backgroundColor: theme.colorScheme.surface,
          selectedColor: theme.colorScheme.primary,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
          side: isSelected
              ? BorderSide.none
              : BorderSide(color: theme.colorScheme.outline),
        );
      }).toList(),
    );
  }
}
