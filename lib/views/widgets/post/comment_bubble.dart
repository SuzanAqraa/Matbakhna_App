import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/Models/comment_model.dart';

import '../../../core/utils/spaces.dart';

class CommentBubble extends StatelessWidget {
  final CommentModel comment;

  const CommentBubble({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          comment.profilePic != null && comment.profilePic!.isNotEmpty
              ? CircleAvatar(backgroundImage: NetworkImage(comment.profilePic!), radius: 20)
              : const CircleAvatar(radius: 20, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
          Spaces.horizontalSpacing(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Spaces.verticalSpacing(6),
                Text(comment.comment, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
