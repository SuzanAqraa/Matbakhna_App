import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matbakhna_mobile/views/screens/login_screen.dart';
import 'package:matbakhna_mobile/views/screens/post_screen.dart';
import 'package:matbakhna_mobile/views/widgets/recipe/bookmark_button.dart';
import 'package:matbakhna_mobile/views/widgets/recipe/like_button.dart';
import 'package:matbakhna_mobile/views/widgets/recipe/share_button.dart';



class RecipeCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String time;
  final int numLikes;
  final int numComments;
    final String recipeId;

  const RecipeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.time,
    required this.numLikes,
    required this.numComments,
    required this.recipeId,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  final bool _isLiked = false;

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('تنبيه'),
            content: const Text(
              'يجب تسجيل الدخول لتتمكن من التفاعل مع هذا الزر.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('تسجيل الدخول'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
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
                    widget.imageUrl,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE56B50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.time,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 10,
                  child: BookmarkButton(
                    onNeedLogin: _showLoginDialog,
                    recipeTitle: widget.title,
                    imageUrl: widget.imageUrl,
                    description: widget.description,
                    duration: widget.time,
                    numLikes: widget.numLikes,
                    numComments: widget.numComments,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D3D3D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF707070),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LikeButton(
                        onNeedLogin: _showLoginDialog,
                        recipeTitle: widget.title,
                        initialLikeCount: widget.numLikes,
                      ),

                      ShareButton(recipeTitle: widget.title),

                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.comment),
                            iconSize: 18,
                            color: const Color(0xFF3D3D3D),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PostPage(recipeId: widget.recipeId,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.numComments} تعليق',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF3D3D3D),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}