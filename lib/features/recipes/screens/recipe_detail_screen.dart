import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../core/utils/brand_colors.dart';
import '../../../core/widgets/SimpleAppBar.dart';
import '../../../Models/recipe_model.dart';

import '../widgets/recipe_video.dart';
import '../widgets/recipe_info.dart';
import '../widgets/ingredients_list.dart';
import '../widgets/steps_list.dart';

class RecipePage extends StatefulWidget {
  final String recipeId;

  const RecipePage({super.key, required this.recipeId});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  RecipeModel? recipe;
  YoutubePlayerController? _controller;
  List<bool> checked = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipe();
  }

  Future<void> fetchRecipe() async {
    try {
      print("Fetching recipe with ID: ${widget.recipeId}");
      final doc = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.recipeId)
          .get();

      print("Document exists: ${doc.exists}");
      if (doc.exists) {
        final data = doc.data();

        if (data != null) {
          final fetchedRecipe = RecipeModel.fromJson(doc.id, data);

          final rawVideoIdOrUrl = data['videoUrl'] ?? '';
          final videoId = YoutubePlayer.convertUrlToId(rawVideoIdOrUrl) ?? '';

          setState(() {
            recipe = fetchedRecipe;
            checked = List<bool>.filled(fetchedRecipe.ingredients.length, false);

            if (videoId.isNotEmpty) {
              _controller = YoutubePlayerController(
                initialVideoId: videoId,
                flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
              );
            } else {
              _controller = null;
            }

            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            recipe = null;
          });
        }
      } else {
        print("Document with ID ${widget.recipeId} not found");
        setState(() {
          isLoading = false;
          recipe = null;
        });
      }
    } catch (e) {
      print("Error fetching recipe: $e");
      setState(() {
        isLoading = false;
        recipe = null;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.backgroundColor,
      appBar: CustomAppBar(
        title: recipe?.title ?? 'جاري التحميل...',
        showBackButton: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : recipe == null
          ? const Center(child: Text("الوصفة غير موجودة"))
          : Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               if (_controller != null)
                RecipeVideoWidget(controller: _controller!),
              const SizedBox(height: 24),
              RecipeInfoWidget(
                serving: recipe!.serving,
                difficulty: '${recipe!.difficulty}/10',
                duration: recipe!.duration,
              ),
              const SizedBox(height: 24),
              IngredientsListWidget(
                ingredients: recipe!.ingredients,
                checked: checked,
                onChanged: (index, value) {
                  setState(() => checked[index] = value ?? false);
                },
              ),
              const SizedBox(height: 24),
              StepsListWidget(
                steps: recipe!.steps.map((e) => e.description).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}