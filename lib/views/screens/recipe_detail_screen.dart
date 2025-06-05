import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/Models/recipe_model.dart';
import 'package:matbakhna_mobile/Repositories/recipe_repository.dart';
import 'package:matbakhna_mobile/Controller/recipe_controller.dart';

import '../../core/utils/brand_colors.dart';
import '../../core/widgets/appbar/simple_appbar.dart';
import '../widgets/recipe/recipe_video.dart';
import '../widgets/recipe/recipe_info.dart';
import '../widgets/recipe/ingredients_list.dart';
import '../widgets/recipe/steps_list.dart';

class RecipePage extends StatefulWidget {
  final String recipeId;

  const RecipePage({super.key, required this.recipeId});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final RecipeController _controller = RecipeController();

  List<bool> checked = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    final recipe = await _controller.fetchRecipe(widget.recipeId);
    if (recipe != null) {
      setState(() {
        checked = List<bool>.filled(recipe.ingredients.length, false);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipe = _controller.recipe;

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
              if (_controller.playerController != null)
                RecipeVideoWidget(controller: _controller.playerController!),
              const SizedBox(height: 24),
              RecipeInfoWidget(
                serving: recipe.serving,
                difficulty: '${recipe.difficulty}/10',
                duration: recipe.duration,
              ),
              const SizedBox(height: 24),
              IngredientsListWidget(
                ingredients: recipe.ingredients,
                checked: checked,
                onChanged: (index, value) {
                  setState(() => checked[index] = value ?? false);
                },
              ),
              const SizedBox(height: 24),
              StepsListWidget(
                steps: recipe.steps.map((e) => e.description).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
