import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  final String recipeTitle;
  final String description = 'وصفة لذيذة وسهلة التحضير.';


  const ShareButton({super.key, required this.recipeTitle});

  void _handleShare() {
    Share.share('شاهد هذه الوصفة المذهلة: $recipeTitle\n\n$description');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _handleShare,
        ),
        const Text('مشاركة'),
      ],
    );
  }
}