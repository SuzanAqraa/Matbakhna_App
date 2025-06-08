import 'package:matbakhna_mobile/Models/recipe_model.dart';
import 'package:matbakhna_mobile/Repositories/post_repository.dart';

class PostController {
  final PostRepository _repository = PostRepository();

  bool isLiked = false;
  int likes = 0;

  static const int likeIncrement = 1;
  static const int likeDecrement = -1;

  Future<RecipeModel?> fetchRecipe(String id) async {
    final recipe = await _repository.getRecipeById(id);
    if (recipe != null) {
      likes = recipe.numLikes;
    }
    return recipe;
  }

  Future<void> toggleLike(String docId) async {
    if (!isLiked) {
      await _repository.incrementLikes(docId, likeIncrement);
      isLiked = true;
      likes += likeIncrement;
    } else {
      await _repository.incrementLikes(docId, likeDecrement);
      isLiked = false;
      likes += likeDecrement;
    }
  }
}
