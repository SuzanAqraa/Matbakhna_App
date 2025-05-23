import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../core/utils/brand_colors.dart';
import '../../../core/widgets/SimpleAppBar.dart';

import '../widgets/recipe_video.dart';
import '../widgets/recipe_info.dart';
import '../widgets/ingredients_list.dart';
import '../widgets/steps_list.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final List<String> ingredients = [];
  final List<String> steps = [];
  late YoutubePlayerController _controller;
  late List<bool> checked;

  String title = '';
  String difficulty = '';
  String duration = '';
  String serving = '';

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'npfExMqhKhg',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    checked = [];
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    final doc = await FirebaseFirestore.instance
        .collection('Recipe')
        .doc('NmwFF7m2kbzF1pjoerNc')
        .get();

    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        setState(() {
          ingredients.clear();
          steps.clear();

          title = data['Title'] ?? '';
          difficulty = data['difficulty'] ?? '';
          duration = data['duration'] ?? '';
          serving = data['serving'] ?? '';

          ingredients.addAll(List<String>.from(data['ingredients']));
          steps.addAll(List<String>.from(data['step']));
          checked = List<bool>.filled(ingredients.length, false);
        });
      }
    } else {
      print("Document does not exist");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onIngredientCheckedChanged(int index, bool? value) {
    setState(() {
      checked[index] = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.backgroundColor,
      appBar: CustomAppBar(
        title: title.isNotEmpty ? title : 'جاري التحميل...',
        showBackButton: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              RecipeVideoWidget(controller: _controller),
              const SizedBox(height: 24),
              RecipeInfoWidget(serving: serving, difficulty: difficulty, duration: duration),
              const SizedBox(height: 24),
              IngredientsListWidget(
                ingredients: ingredients,
                checked: checked,
                onChanged: onIngredientCheckedChanged,
              ),
              const SizedBox(height: 24),
              StepsListWidget(steps: steps),
            ],

          ),
        ),
      ),
    );
  }
}
