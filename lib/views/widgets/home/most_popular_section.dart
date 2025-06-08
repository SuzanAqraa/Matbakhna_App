import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/views/screens/listing_screen.dart';
import '../../../core/utils/icon_styles.dart';
import '../../../core/utils/spaces.dart';
import '../../../core/utils/textfeild_styles.dart';
import 'card.dart';
import 'package:matbakhna_mobile/Models/recipe_model.dart';

class MostPopularSection extends StatelessWidget {
  final List<RecipeModel> recipes;

  const MostPopularSection({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    // Calculate card dimensions based on screen size
    final cardWidth = isSmallScreen 
        ? screenWidth * 0.50 
        : screenWidth > 1200 
            ? 300.0 
            : screenWidth * 0.30;
    
    final cardHeight = isSmallScreen 
        ? screenHeight * 0.35 
        : screenHeight * 0.45;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 32),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'الأكثر تفاعل',
              style: ThemeTextStyle.titleTextFieldStyle.copyWith(
                fontSize: isSmallScreen ? null : 28,
              ),
            ),
          ),
        ),
        Spaces.verticalSpacing(isSmallScreen ? 12 : 20),
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 32),
            itemCount: recipes.length,
            separatorBuilder: (context, index) => Spaces.horizontalSpacing(isSmallScreen ? 12 : 20),
            itemBuilder: (context, index) {
              final recipeModel = recipes[index];
              return RecipeCard(
                recipe: recipeModel,
                width: cardWidth,
                height: cardHeight,
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: isSmallScreen ? 24 : 32,
            top: isSmallScreen ? 12 : 20,
            bottom: isSmallScreen ? 32 : 40,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListingScreen(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'اعرض المزيد',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 18 : 20,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 3 : 6),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: IconStyle.defaultIconColor,
                    size: isSmallScreen ? null : 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
