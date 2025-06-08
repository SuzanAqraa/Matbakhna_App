import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Models/recipe_model.dart';
import '../core/utils/network_helpers/network_utils.dart';

class HomeRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<RecipeModel>> fetchRecipes() async {
    return await handleWithRetry<List<RecipeModel>>(
      request: () async {
        final snapshot = await _firestore.collection('recipes').get();
        return snapshot.docs
            .map((doc) => RecipeModel.fromJson(doc.id, doc.data()))
            .toList();
      },
      fallbackValue: [],
    );
  }

  Future<List<String>> fetchCookingTips() async {
    return await handleWithRetry<List<String>>(
      request: () async {
        final snapshot = await _firestore.collection('Tips').get();
        return snapshot.docs
            .map((doc) => doc.data()['tip']?.toString() ?? '')
            .where((tip) => tip.isNotEmpty)
            .toList();
      },
      fallbackValue: [],
    );
  }
}
