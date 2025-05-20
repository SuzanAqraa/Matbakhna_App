import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/features/listing/screens/listing_screen.dart';
import '../../../core/utils/icon_styles.dart';
import '../../../core/utils/textfeild_styles.dart';
import 'card.dart';

class MostPopularSection extends StatelessWidget {
  final List<Map<String, dynamic>> recipes;

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
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,

            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recipes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return GestureDetector(
                onTap: null,
                child: SizedBox(
                  width: 200,
                  child: RecipeCard(
                    imageUrl: recipe['imageUrl'] ?? '',
                    title: recipe['title'] ?? '',
                    description: recipe['description'] ?? '',
                    time: recipe['time'] ?? '',
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
                  const Text(
                    'اعرض المزيد',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(
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
