import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/core/widgets/custom_widgets.dart';

import '../../../core/widgets/custom_bottom_navbar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA5C8A6),
        title: const Text('المحفوظات'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('المحفوظات ستكون هنا'),
      ),
      bottomNavigationBar: CustomBottomNavbar(currentIndex: 2),

    );
  }
}
