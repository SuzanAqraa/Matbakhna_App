import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/features/home/widgets/card.dart';
import 'package:matbakhna_mobile/features/listing/screens/listing_screen.dart';
import 'package:matbakhna_mobile/features/recipes/screens/recipe_detail_screen.dart';

class MostPopularSection extends StatelessWidget {
  final List<Map<String, String>> recipes;

  const MostPopularSection({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'الأكثر تفاعل',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D3D3D),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recipes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipePage(), // must be  RecipePage(recipe: recipe)
                    ),
                  );
                },
                child: SizedBox(
                  width: 200,
                  child: RecipeCard(
                    imageUrl: recipe['imageUrl']!,
                    title: recipe['title']!,
                    description: recipe['description']!,
                    time: recipe['time']!,
                  ),
                ),
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
                  MaterialPageRoute(builder: (context) => const ListingScreen()),
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
                      color: Color(0xFF3D3D3D),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF3D3D3D),
                    size: 11,
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
