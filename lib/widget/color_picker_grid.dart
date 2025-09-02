import 'package:flutter/material.dart';

class ColorPickerGrid extends StatelessWidget {
  final int selectedColor;
  final ValueChanged<int> onColorSelected;

  ColorPickerGrid({
    Key? key,
    required this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

  final List<int> _colors = [
    0xFFEF9A9A, // Red
    0xFFF48FB1, // Pink
    0xFFCE93D8, // Purple
    0xFFB39DDB, // Deep Purple
    0xFF9FA8DA, // Indigo
    0xFF90CAF9, // Blue
    0xFF81D4FA, // Light Blue
    0xFF80DEEA, // Cyan
    0xFF80CBC4, // Teal
    0xFFA5D6A7, // Green
    0xFFC5E1A5, // Light Green
    0xFFE6EE9C, // Lime
    0xFFFFF59D, // Yellow
    0xFFFFE082, // Amber
    0xFFFFCC80, // Orange
    0xFFFFAB91, // Deep Orange
    0xFFBCAAA4, // Brown
    0xFFE0E0E0, // Grey
    0xFFB0BEC5, // Blue Grey
    0xFFB3E5FC, // Light Sky Blue (default)
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _colors.map((color) {
        final isSelected = color == selectedColor;
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Color(color),
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 18, color: Colors.black)
                : null,
          ),
        );
      }).toList(),
    );
  }
}

