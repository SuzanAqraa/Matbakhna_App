import 'package:flutter/material.dart';

import '../../../core/widgets/PrimaryAppBar.dart';
import '../../../core/widgets/custom_bottom_navbar.dart';

class ListingScreen extends StatelessWidget {
  const ListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5EC),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: const [
              HomeAppBar(title: 'صفحة التصفح'),
              SizedBox(height: 20),
              // هنا ضع باقي محتوى الصفحة مثل قائمة الوصفات أو الفلاتر
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(currentIndex: 3),

    );
  }
}
