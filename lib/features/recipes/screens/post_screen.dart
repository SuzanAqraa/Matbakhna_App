import 'package:flutter/material.dart';

import '../../../core/widgets/SimpleAppBar.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF5EC),
        appBar: const CustomAppBar(
          title: ' المنشور',
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
                  Image.network(
                    'https://kitchen.sayidaty.net/uploads/small/65/65a750957fd3d95431c6c55a9fb02237_w750_h500.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: const Text(
                      'طبق شعبي يتكون من الحمص المطحون مع البهارات، ويُقلى بالزيت',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black54,
                          ),
                        ],
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
                children: const [
                  Text(
                    '2 تعليق',
                    style: TextStyle(fontSize: 16, color: Color(0xFF3D3D3D)),
                  ),
                  Spacer(),
                  Text(
                    '58 اعجاب',
                    style: TextStyle(fontSize: 16, color: Color(0xFF3D3D3D)),
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
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border, color: Colors.black, size: 24),
                    label: const Text('أعجبني',
                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.comment_outlined, color: Colors.black, size: 24),
                    label: const Text('تعليق',
                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share_outlined, color: Colors.black, size: 24),
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
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: const [
                        CommentBubble(
                            username: 'دانا مرجان',
                            text: 'بصراحة حبيت الطريقة ونجحت معي الوصفة ١٠٠٪'),
                        CommentBubble(
                            username: 'سوزان اقرع',
                            text: 'طريقة سهلة والنتيجة لذيذة :)'),
                      ],
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
                                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
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
      ),
    );
  }
}

class CommentBubble extends StatelessWidget {
  final String username;
  final String text;

  const CommentBubble({super.key, required this.username, required this.text});

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
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
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
