import 'package:flutter/material.dart';
import '../../../core/utils/brand_colors.dart';

class StepsListWidget extends StatelessWidget {
  final List<String> steps;

  const StepsListWidget({super.key, required this.steps});

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
            'الخطوات',
            style: TextStyle(
              fontSize: isSmallScreen ? 36 : 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 8 : 16),
        Column(
          children: steps.asMap().entries.map((entry) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 6 : 12),
              padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
              decoration: BoxDecoration(
                color: BrandColors.secondaryBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: isSmallScreen ? 14 : 20,
                    backgroundColor: BrandColors.secondaryColor,
                    child: Text(
                      '${entry.key + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 14 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 12 : 20),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
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
