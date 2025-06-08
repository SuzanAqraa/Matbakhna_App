import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/controller/comment_controller.dart';
import 'package:matbakhna_mobile/core/utils/spaces.dart';

class SendCommentWidget extends StatelessWidget {
  final CommentController controller;
  final VoidCallback onSend;

  const SendCommentWidget({
    Key? key,
    required this.controller,
    required this.onSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.textController,
              decoration: InputDecoration(
                hintText: 'اكتب تعليقك...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Spaces.horizontalSpacing(8),
          IconButton(
            onPressed: onSend,
            icon: const Icon(Icons.send, color: Color(0xFFE56B50)),
          ),
        ],
      ),
    );
  }
}
