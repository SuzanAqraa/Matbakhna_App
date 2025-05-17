import 'package:flutter/material.dart';

import '../../../core/widgets/custom_bottom_navbar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5EC), // ← تمت إضافة اللون هنا
      appBar: AppBar(
        backgroundColor: const Color(0xFFA5C8A6),
        title: const Text('المحفوظات'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: const Center(child: Text('المحفوظات ستكون هنا')),
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 2),
    );
  }
}
