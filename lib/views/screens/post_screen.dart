import 'dart:async';
import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/core/widgets/appbar/simple_appbar.dart';
import 'package:matbakhna_mobile/Models/recipe_model.dart';
import 'package:matbakhna_mobile/Views/widgets/post/comments_list.dart';
import 'package:matbakhna_mobile/Views/widgets/post/post_header.dart';
import 'package:matbakhna_mobile/Views/widgets/post/post_comment_input.dart';
import 'package:matbakhna_mobile/controller/comment_controller.dart';
import 'package:matbakhna_mobile/controller/post_controller.dart';
import 'package:matbakhna_mobile/repositories/user_repository.dart';

import '../../core/utils/network_helpers/network_utils.dart';

class PostPage extends StatefulWidget {
  final String recipeId;

  const PostPage({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostController _controller = PostController();
  final CommentController _commentController = CommentController();
  final UserRepository _userRepository = UserRepository();

  late Future<RecipeModel?> _recipeFuture;

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  void _loadRecipe() {
    _recipeFuture = handleWithRetry<RecipeModel?>(
      request: () => _controller.fetchRecipe(widget.recipeId),
      maxRetries: 3,
      fallbackValue: null,
      retryDelay: const Duration(seconds: 2),
    );
  }

  Future<void> _refresh() async {
    _loadRecipe();
    setState(() {});
    await _recipeFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF5EC),
        body: FutureBuilder<RecipeModel?>(
          future: _recipeFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("حدثت مشكلة في الاتصال بالإنترنت"));
            }

            final recipe = snapshot.data!;

            return Scaffold(
              backgroundColor: const Color(0xFFFDF5EC),
              appBar: CustomAppBar(title: recipe.title, showBackButton: true),
              body: RefreshIndicator(
                onRefresh: _refresh,
                child: Column(
                  children: [
                    PostHeader(recipe: recipe),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        children: [
                          Text('${recipe.comments.length} تعليق'),
                          const Spacer(),
                          Text('${_controller.likes} اعجاب'),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1.2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              await _controller.toggleLike(recipe.id);
                              _loadRecipe();
                              setState(() {});
                            },
                            icon: Icon(
                              _controller.isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _controller.isLiked ? Colors.red : Colors.black,
                            ),
                            label: const Text('أعجبني'),
                          ),
                          TextButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.comment_outlined, color: Colors.black),
                            label: const Text('تعليق'),
                          ),
                          TextButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.share_outlined, color: Colors.black),
                            label: const Text('مشاركة'),
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1.2),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(child: CommentsList(comments: recipe.comments)),
                          const Divider(thickness: 1.2),
                          SendCommentWidget(
                            controller: _commentController,
                            onSend: () async {
                              final userData = await _userRepository.getUserData(_userRepository.currentUser!.uid);

                              if (userData == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("فشل في تحميل بيانات المستخدم")),
                                );
                                return;
                              }

                              final username = userData.data()?['username'] ?? 'مستخدم';
                              final profilePic = userData.data()?['profilepic'];

                              try {
                                await _commentController.sendComment(
                                  recipeId: recipe.id,
                                  username: username,
                                  profilePic: profilePic,
                                );

                                _loadRecipe();
                                setState(() {});
                                _commentController.clear();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("حدث خطأ أثناء إرسال التعليق")),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
