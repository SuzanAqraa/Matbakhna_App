import 'package:flutter/material.dart';
import '../../../core/utils/brand_colors.dart';

class StepsListWidget extends StatelessWidget {
  final List<String> steps;

  const StepsListWidget({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'الخطوات',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Column(
          children: steps.asMap().entries.map((entry) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BrandColors.secondaryBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: BrandColors.secondaryColor,
                    child: Text('${entry.key + 1}', style: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(entry.value)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
