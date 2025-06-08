import 'package:flutter/material.dart';
import '../../../core/utils/brand_colors.dart';

class IngredientsListWidget extends StatelessWidget {
  final List<String> ingredients;
  final List<bool> checked;
  final void Function(int, bool?) onChanged;

  const IngredientsListWidget({
    super.key,
    required this.ingredients,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'المكونات',
            style: TextStyle(
              fontSize: isSmallScreen ? 36 : 48,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
        SizedBox(height: isSmallScreen ? 12 : 20),
        Container(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 24),
          decoration: BoxDecoration(
            border: Border.all(color: BrandColors.secondaryColor),
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: ingredients.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return CheckboxListTile(
                title: Text(
                  item,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                  ),
                ),
                value: checked[index],
                onChanged: (value) => onChanged(index, value),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: BrandColors.secondaryColor,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
