import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/views/screens/post_screen.dart';
import 'package:matbakhna_mobile/views/screens/recipe_detail_screen.dart';

class RecipeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String time;
  final int numLikes;
  final int numComments;

  const RecipeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.time,
    required this.numLikes,
    required this.numComments,
  });

  void _goToPostPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PostPage(recipeId: '1')),
    );
  }

  void _goToRecipeDetailPage(BuildContext context) {
    // Navigator.push(
    //   context,
    //  // MaterialPageRoute(builder: (context) => const RecipePage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 200,
      child: Container(
        padding: const EdgeInsets.all(8),
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
                  color: const Color(0xFFFDF5EC),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE56B50),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              time,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                    
                          ),
                        
                        ),
                      Padding(padding: const EdgeInsets.only(right: 10,top: 8),
                      child:Icon(Icons.bookmark_border, color: Colors.black, size: 30,),
                     ), ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3D3D3D),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        height: 48,
                        child: SingleChildScrollView(
                          child: Text(
                            description,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF707070),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _goToPostPage(context),
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite_border, size: 18, color: Color(0xFF3D3D3D)),
                        const SizedBox(width: 4),
                        Text('$numLikes إعجاب', style: const TextStyle(fontSize: 18, color: Color(0xFF3D3D3D))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.share, size: 18, color: Color(0xFF3D3D3D)),
                        const SizedBox(width: 4),
                        const Text('مشاركة', style: TextStyle(fontSize: 18, color: Color(0xFF3D3D3D))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.comment, size: 18, color: Color(0xFF3D3D3D)),
                        const SizedBox(width: 4),
                        Text('$numComments تعليق', style: const TextStyle(fontSize: 18, color: Color(0xFF3D3D3D))),
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
