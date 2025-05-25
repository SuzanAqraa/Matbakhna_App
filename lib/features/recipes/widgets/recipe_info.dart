import 'package:flutter/material.dart';
import '../../../core/utils/brand_colors.dart';

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
        Column(
          children: [
            const Icon(Icons.group_outlined, color: Colors.black),
            Text(serving.isNotEmpty ? serving : '...', style: const TextStyle(fontSize: 16)),
          ],
        ),
        Column(
          children: [
            const Icon(Icons.star_outline, color: Colors.black),
            Transform.translate(
              offset: const Offset(5, 0),
              child: Text(difficulty.isNotEmpty ? difficulty : '...', style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
        Column(
          children: [
            const Icon(Icons.access_time_outlined, color: Colors.black),
            Text(duration.isNotEmpty ? duration : '...', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }
}
