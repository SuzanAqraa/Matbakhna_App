import 'package:flutter/material.dart';

import '../../../core/widgets/SimpleAppBar.dart';
import '../../../core/widgets/custom_bottom_navbar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5EC),
      appBar: const CustomAppBar(
        title: 'الوصفات المفضلة',
        showBackButton: false,
      ),      body: const Center(child: Text('الوصفات المفضلة ستكون هنا')),
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 2),
    );
  }
}
