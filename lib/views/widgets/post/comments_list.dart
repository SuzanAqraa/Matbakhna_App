import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/Models/comment_model.dart';
import 'comment_bubble.dart';

class CommentsList extends StatelessWidget {
  final List<CommentModel> comments;

  const CommentsList({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد تعليقات بعد.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: comments.map((comment) => CommentBubble(comment: comment)).toList(),
    );
  }
}