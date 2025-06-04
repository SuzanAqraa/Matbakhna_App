import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matbakhna_mobile/Models/recipe_model.dart';

class PostRepository {
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

  Future<void> incrementLikes(String docId, int value) async {
    try {
      await _firestore.collection('recipes').doc(docId).update({
        'Num_Likes': FieldValue.increment(value),
      });
    } catch (e) {
      print("Error updating likes: $e");
    }
  }
}
