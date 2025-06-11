import 'dart:math';
import 'package:matbakhna_mobile/Models/recipe_model.dart';

import '../repositories/home_repository.dart';

class HomeController {
  final HomeRepository _repository = HomeRepository();

  static const int popularRecipesCount = 5;
  static const int yearMultiplier = 10000;
  static const int monthMultiplier = 100;

  Future<List<RecipeModel>> getSortedRecipes() async {
    final recipes = await _repository.fetchRecipes();

    final withInteractions = recipes.map((r) {
      final total = r.numLikes + r.numComments;
      return {'model': r, 'totalInteractions': total};
    }).toList();


    withInteractions.sort((a, b) {
      final totalA = a['totalInteractions'] as int;
      final totalB = b['totalInteractions'] as int;

      int cmp = totalB.compareTo(totalA);
      if (cmp != 0) return cmp;

      final modelA = a['model'] as RecipeModel;
      final modelB = b['model'] as RecipeModel;

      cmp = modelB.numComments.compareTo(modelA.numComments);
      if (cmp != 0) return cmp;

      return modelB.numLikes.compareTo(modelA.numLikes);
    });

    return withInteractions.map((e) => e['model'] as RecipeModel).toList();
  }

  RecipeModel pickRandomRecipe(List<RecipeModel> recipes) {
    DateTime now = DateTime.now();
    int seed = now.year * yearMultiplier + now.month * monthMultiplier + now.day;
    return recipes[Random(seed).nextInt(recipes.length)];
  }

  List<RecipeModel> getPopularRecipes(List<RecipeModel> sorted) {
    bool hasInteractions = sorted.any((r) => r.numLikes + r.numComments > 0);
    if (hasInteractions) return sorted.take(popularRecipesCount).toList();
    return List<RecipeModel>.from(sorted)..shuffle();
  }

  Future<List<String>> getTips() async {
    return _repository.fetchCookingTips();
  }
}
