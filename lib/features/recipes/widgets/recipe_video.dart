import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/utils/brand_colors.dart';

class RecipeVideoWidget extends StatelessWidget {
  final YoutubePlayerController controller;

  const RecipeVideoWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.initialVideoId.isEmpty) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'فيديو التحضير',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: BrandColors.secondaryColor,
          ),
        ),
      ],
    );
  }
}
