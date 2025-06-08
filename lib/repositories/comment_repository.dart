import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/comment_model.dart';

class CommentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComment(String recipeId, CommentModel comment) async {
    final docRef = _firestore.collection('recipes').doc(recipeId);

    await docRef.set({
      'comments': FieldValue.arrayUnion([comment.toMap()]),
    }, SetOptions(merge: true));
  }
}
