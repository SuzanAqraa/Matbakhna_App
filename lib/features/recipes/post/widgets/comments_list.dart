import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/Models/CommentModel.dart';
import 'comment_bubble.dart';

class CommentsList extends StatelessWidget {
  final List<CommentModel> comments;

  const CommentsList({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return CommentBubble(comment: comments[index]);
      },
    );
  }
}
