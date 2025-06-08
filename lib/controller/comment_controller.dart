import 'package:flutter/material.dart';
import '../Models/comment_model.dart';
import '../repositories/comment_repository.dart';

class CommentController {
  final CommentRepository _repository = CommentRepository();
  final TextEditingController textController = TextEditingController();

  bool get isValid => textController.text.trim().isNotEmpty;

  String get comment => textController.text.trim();

  Future<void> sendComment({
    required String recipeId,
    required String username,
    String? profilePic,
  }) async {
    if (!isValid) return;

    final commentModel = CommentModel(
      username: username,
      comment: comment,
      profilePic: profilePic,
    );

    await _repository.addComment(recipeId, commentModel);
  }

  void clear() {
    textController.clear();
  }
}
