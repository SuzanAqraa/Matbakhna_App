import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/core/widgets/appbar/simple_appbar.dart';
import 'package:matbakhna_mobile/Models/recipe_model.dart';

import 'package:matbakhna_mobile/core/utils/spaces.dart';
import 'package:matbakhna_mobile/views/widgets/post/comments_list.dart';
import 'package:matbakhna_mobile/views/widgets/post/post_header.dart';
import 'package:matbakhna_mobile/views/widgets/recipe/share_button.dart';

import '../../controller/post_controller.dart';

class PostPage extends StatefulWidget {
  final String recipeId;

  const PostPage({super.key, required this.recipeId});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostController _controller = PostController();

  late Future<RecipeModel?> _recipeFuture;

  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  void _loadRecipe() {
    _recipeFuture = _controller.fetchRecipe(widget.recipeId);
  }

  Future<void> _refresh() async {
    _loadRecipe();
    setState(() {});
    await _recipeFuture;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
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
              return const Center(child: Text("الوصفة غير موجودة"));
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
                              setState(() {});
                            },
                            icon: Icon(
                              _controller.isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _controller.isLiked ? Colors.red : Colors.black,
                            ),
                            label: const Text('أعجبني'),
                          ),
                         
                          ShareButton(recipeTitle: recipe.title),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1.2),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(child: CommentsList(comments: recipe.comments)),
                          const Divider(thickness: 1.2),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _commentController,
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
                                  onPressed: () async {},
                                  icon: const Icon(Icons.send, color: Color(0xFFE56B50)),
                                ),
                              ],
                            ),
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