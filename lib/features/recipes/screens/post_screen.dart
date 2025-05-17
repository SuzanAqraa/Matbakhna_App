import 'package:flutter/material.dart';

import '../../../core/widgets/SimpleAppBar.dart';
import '../../../core/widgets/custom_bottom_navbar.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF5EC),
        appBar: const CustomAppBar(
          title: 'المنشور',
          showBackButton: true,
        ),
        body: const Center(child: Text('المنشور سيكون هنا')),
        bottomNavigationBar: const CustomBottomNavbar(currentIndex: 2),
      ),
    );
  }
}
