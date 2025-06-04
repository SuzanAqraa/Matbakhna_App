import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/core/widgets/appbar/simple_appbar.dart';
import 'package:matbakhna_mobile/Models/recipe_model.dart';
import 'package:matbakhna_mobile/Views/widgets/post/comments_list.dart';
import 'package:matbakhna_mobile/Views/widgets/post/post_header.dart';
import 'package:matbakhna_mobile/core/utils/spaces.dart';

import '../../controller/post_controller.dart';

class PostPage extends StatefulWidget {
  final String recipeId;

  const PostPage({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostController _controller = PostController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF5EC),
        body: FutureBuilder<RecipeModel?>(
          future: _controller.fetchRecipe(widget.recipeId),
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
              body: Column(
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
                         TextButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.comment_outlined, color: Colors.black),
                          label: Text('تعليق'),
                        ),
                         TextButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.share_outlined, color: Colors.black),
                          label: Text('مشاركة'),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
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
                                onPressed: () {},
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
            );
          },
        ),
      ),
    );
  }
}
