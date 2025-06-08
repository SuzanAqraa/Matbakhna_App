import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/utils/brand_colors.dart';

class RecipeVideoWidget extends StatelessWidget {
  final YoutubePlayerController controller;

  const RecipeVideoWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.initialVideoId.isEmpty) {
      return const SizedBox();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'فيديو التحضير',
            style: TextStyle(
              fontSize: isSmallScreen ? 24 : 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 12 : 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: isSmallScreen ? 16 / 9 : 21 / 9,
            child: YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: BrandColors.secondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
