import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Models/recipe_model.dart';

class HomeRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<RecipeModel>> fetchRecipes() async {
    final snapshot = await _firestore.collection('recipes').get();
    return snapshot.docs
        .map((doc) => RecipeModel.fromJson(doc.id, doc.data()))
        .toList();
  }

  Future<List<String>> fetchCookingTips() async {
    final snapshot = await _firestore.collection('Tips').get();
    return snapshot.docs
        .map((doc) => doc.data()['tip']?.toString() ?? '')
        .where((tip) => tip.isNotEmpty)
        .toList();
  }
}
