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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'الأكثر تفاعل',
              style: ThemeTextStyle.titleTextFieldStyle,
            ),
          ),
        ),
        Spaces.verticalSpacing(12),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recipes.length,
            separatorBuilder: (context, index) => Spaces.horizontalSpacing(12),
            itemBuilder: (context, index) {
              final recipeModel = recipes[index];
              return SizedBox(
                width: 200,
                child: RecipeCard(recipe: recipeModel),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 12, bottom: 32),
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
                children: const [
                  Text(
                    'اعرض المزيد',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: IconStyle.defaultIconColor,
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
