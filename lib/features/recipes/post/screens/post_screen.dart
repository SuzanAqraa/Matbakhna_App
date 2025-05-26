import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/simple_appbar.dart';
import 'package:matbakhna_mobile/Models/recipe_model.dart';

import '../widgets/comments_list.dart';
import '../widgets/post_header.dart';

class PostPage extends StatefulWidget {
  final String recipeId;

  const PostPage({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool isLiked = false;
  int likes = 0;

  void toggleLike(String docId) async {
    final recipeRef = FirebaseFirestore.instance.collection('recipes').doc(docId);

    if (!isLiked) {
      await recipeRef.update({'Num_Likes': FieldValue.increment(1)});
      setState(() {
        isLiked = true;
        likes++;
      });
    } else {
      await recipeRef.update({'Num_Likes': FieldValue.increment(-1)});
      setState(() {
        isLiked = false;
        likes--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF5EC),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('recipes').doc(widget.recipeId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("الوصفة غير موجودة"));
            }

            final doc = snapshot.data!;
            final recipe = RecipeModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
            likes = recipe.numLikes;

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
                        Text('${recipe.comments.length} تعليق', style: const TextStyle(fontSize: 16, color: Color(0xFF3D3D3D))),
                        const Spacer(),
                        Text('$likes اعجاب', style: const TextStyle(fontSize: 16, color: Color(0xFF3D3D3D))),
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
                          onPressed: () => toggleLike(recipe.id),
                          icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.black),
                          label: const Text('أعجبني',
                              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.comment_outlined, color: Colors.black),
                          label: const Text('تعليق',
                              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined, color: Colors.black),
                          label: const Text('مشاركة',
                              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
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
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                },
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
