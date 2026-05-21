import 'package:flutter/material.dart';
import '../constants/color_palette.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? ColorPalette.primary : ColorPalette.secondary;
    return ChoiceChip(
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
      selected: selected,
      selectedColor: color.withValues(alpha: 0.18),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w700),
      onSelected: (_) => onTap(),
      elevation: 0,
      pressElevation: 0,
      clipBehavior: Clip.antiAlias,
    );
  }
}
