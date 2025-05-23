import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/SimpleAppBar.dart';

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

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final title = data['Title'] ?? 'المنشور';
            final description = data['Description'] ?? '';
            final imageUrl = data['imageUrl'] ?? '';
            likes = data['Num_Likes'] ?? 0;
            final comments = List<Map<String, dynamic>>.from(data['comments'] ?? []);

            return Scaffold(
              backgroundColor: const Color(0xFFFDF5EC),
              appBar: CustomAppBar(
                title: title,
                showBackButton: true,
              ),
              body: Column(
                children: [
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(imageUrl, fit: BoxFit.cover),
                        Container(
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Text(
                            description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              shadows: [Shadow(offset: Offset(0, 1), blurRadius: 3, color: Colors.black54)],
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Text(
                          '${comments.length} تعليق',
                          style: const TextStyle(fontSize: 16, color: Color(0xFF3D3D3D)),
                        ),
                        const Spacer(),
                        Text(
                          '$likes اعجاب',
                          style: const TextStyle(fontSize: 16, color: Color(0xFF3D3D3D)),
                        ),
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
                          onPressed: () => toggleLike(widget.recipeId),
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.black,
                          ),
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
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              return CommentBubble(
                                username: comment['username'] ?? 'مستخدم',
                                text: comment['comment'] ?? '',
                                profilePic: comment['profilepic'],
                              );
                            },
                          ),
                        ),
                        SafeArea(
                          top: false,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: const BoxDecoration(
                              border: Border(top: BorderSide(color: Colors.grey)),
                              color: Color(0xFFFDF5EC),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    style: const TextStyle(fontSize: 18),
                                    decoration: InputDecoration(
                                      hintText: 'تعليق...',
                                      hintStyle: const TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  icon: const Icon(Icons.send, color: Color(0xFFE56B50), size: 30),
                                  onPressed: () {},
                                ),
                              ],
                            ),
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

class CommentBubble extends StatelessWidget {
  final String username;
  final String text;
  final String? profilePic;

  const CommentBubble({super.key, required this.username, required this.text, this.profilePic});

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
          profilePic != null && profilePic!.isNotEmpty
              ? CircleAvatar(backgroundImage: NetworkImage(profilePic!), radius: 20)
              : const CircleAvatar(radius: 20, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 6),
                Text(text, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
