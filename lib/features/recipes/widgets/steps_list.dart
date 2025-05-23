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
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'الخطوات',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
        const SizedBox(height: 8),
        steps.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: steps.asMap().entries.map((entry) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BrandColors.secondaryBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 28),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: BrandColors.secondaryColor,
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
