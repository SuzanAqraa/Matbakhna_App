import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/Models/recipe_model.dart';
import 'package:matbakhna_mobile/controller/recipe_controller.dart';

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
  String? sharedImageUrl; 

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
        sharedImageUrl = recipe.imageUrl; 
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final horizontalPadding = isSmallScreen ? 16.0 : 32.0;

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
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_controller.playerController != null)
                              RecipeVideoWidget(controller: _controller.playerController!),
                            SizedBox(height: isSmallScreen ? 24 : 32),
                            RecipeInfoWidget(
                              serving: recipe.serving,
                              difficulty: '${recipe.difficulty}/10',
                              duration: recipe.duration,
                            ),
                            SizedBox(height: isSmallScreen ? 24 : 32),
                            IngredientsListWidget(
                              ingredients: recipe.ingredients,
                              checked: checked,
                              onChanged: (index, value) {
                                setState(() => checked[index] = value ?? false);
                              },
                            ),
                            SizedBox(height: isSmallScreen ? 24 : 32),
                            StepsListWidget(
                              recipeId: recipe.id,
                              steps: recipe.steps.map((e) => {'description': e.description}).toList(),
                              sharedImageUrl: sharedImageUrl, 
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}