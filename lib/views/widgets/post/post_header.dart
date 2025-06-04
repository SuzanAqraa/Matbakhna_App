import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/Models/recipe_model.dart';

class PostHeader extends StatelessWidget {
  final RecipeModel recipe;

  const PostHeader({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(recipe.imageUrl, fit: BoxFit.cover),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Text(
              recipe.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                shadows: [Shadow(offset: Offset(0, 1), blurRadius: 3, color: Colors.black54)],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
