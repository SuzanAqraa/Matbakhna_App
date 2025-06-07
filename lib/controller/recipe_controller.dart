import 'package:matbakhna_mobile/Models/recipe_model.dart';
import 'package:matbakhna_mobile/Repositories/recipe_repository.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecipeController {
  final RecipeRepository _repository = RecipeRepository();

  RecipeModel? recipe;
  YoutubePlayerController? playerController;

  Future<RecipeModel?> fetchRecipe(String id) async {
    final fetchedRecipe = await _repository.getRecipeById(id);
    if (fetchedRecipe != null) {
      final videoId = YoutubePlayer.convertUrlToId(fetchedRecipe.videoUrl) ?? '';
      if (videoId.isNotEmpty) {
        playerController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
        );
      }
    }
    recipe = fetchedRecipe;
    return fetchedRecipe;
  }

  void disposePlayer() {
    playerController?.dispose();
  }
}
