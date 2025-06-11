import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/views/screens/recipe_step_screen.dart';
import '../../../core/utils/brand_colors.dart';

class StepsListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> steps;
  final String recipeId;
  final String? sharedImageUrl; 

  const StepsListWidget({
    super.key,
    required this.steps,
    required this.recipeId,
    this.sharedImageUrl, 
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
            final index = entry.key + 1;

            final Map<String, dynamic>? stepData = entry.value as Map<String, dynamic>?;
            final String description = stepData?['description'] ?? 'لا يوجد وصف';
            final String stepText = 'الخطوة $description'; 

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeStepPage(
                      recipeId: recipeId,
                      stepNumber: index,
                      sharedImageUrl: sharedImageUrl,
                    ),
                  ),
                );
              },
              child: Container(
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
                        '$index',
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
                        stepText,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}