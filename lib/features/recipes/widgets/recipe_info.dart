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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildInfoItem(Icons.group_outlined, serving),
        _buildInfoItem(Icons.star_outline, difficulty),
        _buildInfoItem(Icons.access_time_outlined, duration),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.black),
        Text(text.isNotEmpty ? text : '...', style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
