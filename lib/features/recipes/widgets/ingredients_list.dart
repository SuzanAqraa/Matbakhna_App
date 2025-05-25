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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'المكونات',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: BrandColors.secondaryColor),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: ingredients.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: ingredients.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return CheckboxListTile(
                title: Text(
                  item,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
                value: checked[index],
                activeColor: BrandColors.secondaryColor,
                checkColor: Colors.white,
                onChanged: (value) => onChanged(index, value),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                visualDensity: const VisualDensity(vertical: -2),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

}
