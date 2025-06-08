import 'package:flutter/material.dart';

class RecipeInfoWidget extends StatelessWidget {
  final String serving;
  final String difficulty;
  final String duration;

  const RecipeInfoWidget({
    super.key,
    required this.serving,
    required this.difficulty,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(Icons.group_outlined, serving, isSmallScreen),
          _buildInfoItem(Icons.psychology, difficulty, isSmallScreen),
          _buildInfoItem(Icons.access_time_outlined, duration, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, bool isSmallScreen) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.black,
          size: isSmallScreen ? 24 : 32,
        ),
        SizedBox(height: isSmallScreen ? 4 : 8),
        Text(
          text.isNotEmpty ? text : '...',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
