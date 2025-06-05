import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matbakhna_mobile/Models/recipe_model.dart';

class RecipeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<RecipeModel?> getRecipeById(String id) async {
    try {
      final doc = await _firestore.collection('recipes').doc(id).get();
      if (doc.exists) {
        return RecipeModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Error fetching recipe: $e");
      return null;
    }
  }
}
