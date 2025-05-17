import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/core/utils/brand_colors.dart';
import 'package:matbakhna_mobile/core/utils/icon_styles.dart';
import 'package:matbakhna_mobile/core/utils/textfeild_styles.dart';
import 'package:matbakhna_mobile/features/recipes/screens/post_screen.dart';
import 'package:matbakhna_mobile/features/recipes/screens/recipe_detail_screen.dart';

class RecipeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String time;

  const RecipeCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.time,
  }) : super(key: key);

  void _goToPostPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PostPage()),
    );
  }

  void _goToRecipeDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecipePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 250,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _goToRecipeDetailPage(context),
              child: Container(
                decoration: BoxDecoration(
                  color: BrandColors.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: BrandColors.secondaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              time,
                              style: ThemeTextStyle.interActionTextFieldStyle.copyWith(color: Colors.white)
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ThemeTextStyle.recipeNameTextFieldStyle,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        height: 65,
                        child: SingleChildScrollView(
                          child: Text(
                            description,
                            style: ThemeTextStyle.bodySmallTextFieldStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Bar
            GestureDetector(
              onTap: () => _goToPostPage(context),
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  color: BrandColors.secondaryBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border,
                            size: IconStyle.smallIconSize,
                            color: IconStyle.smallIconColor),                        const SizedBox(width: 4),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '58',
                            style: ThemeTextStyle.smallTextFieldStyle
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.comment_outlined,
                            size: IconStyle.smallIconSize,
                            color: IconStyle.smallIconColor),
                        const SizedBox(width: 4),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '21',
                            style: ThemeTextStyle.smallTextFieldStyle
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
