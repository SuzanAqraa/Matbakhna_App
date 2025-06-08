import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../Models/recipe_model.dart';
import '../../../core/utils/brand_colors.dart';
import '../../../core/utils/network_helpers/recipe_image_with_placeholder.dart';
import '../../../core/utils/spaces.dart';
import '../../../core/utils/textfeild_styles.dart';
import '../../screens/recipe_detail_screen.dart';

class TryTodaySection extends StatelessWidget {
  final RecipeModel recipe;

  const TryTodaySection({super.key, required this.recipe});

  void _goToRecipeDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipePage(recipeId: recipe.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final imageSize = isSmallScreen ? 130.0 : 200.0;
    final horizontalPadding = isSmallScreen ? 16.0 : 32.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: GestureDetector(
        onTap: () => _goToRecipeDetailPage(context),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
          decoration: BoxDecoration(
            color: BrandColors.secondaryBackgroundColor,
            borderRadius: BorderRadius.circular(20),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: NetworkImageWithPlaceholder(
                  imageUrl: recipe.imageUrl,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                ),
              ),
              Spaces.horizontalSpacing(isSmallScreen ? 16 : 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'جرب اليوم',
                      style: ThemeTextStyle.interActionTextFieldStyle.copyWith(
                        color: BrandColors.secondaryColor,
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spaces.verticalSpacing(6),
                    Text(
                      recipe.title,
                      style: ThemeTextStyle.titleTextFieldStyle.copyWith(
                        fontSize: isSmallScreen ? 24 : 28,
                      ),
                    ),
                    Spaces.verticalSpacing(6),
                    Text(
                      recipe.description,
                      maxLines: isSmallScreen ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeTextStyle.bodySmallTextFieldStyle.copyWith(
                        fontSize: isSmallScreen ? null : 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
