import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/features/auth/screens/profile/profile_screen.dart';
import 'package:matbakhna_mobile/features/favorites/screens/favorites_screen.dart';
import 'package:matbakhna_mobile/features/home/screens/home_screen.dart';
import 'package:matbakhna_mobile/features/listing/screens/listing_screen.dart';

import 'package:matbakhna_mobile/core/utils/brand_colors.dart';
import 'package:matbakhna_mobile/core/utils/icon_styles.dart';
import 'package:matbakhna_mobile/core/utils/textfeild_styles.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavbar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: IconStyle.selectedItemColor,
      unselectedItemColor: IconStyle.unselectedItemColor,
      backgroundColor: Colors.white,
      selectedLabelStyle: ThemeTextStyle.interActionTextFieldStyle,
      unselectedLabelStyle: ThemeTextStyle.bodySmallTextFieldStyle,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesScreen()),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ListingScreen()),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'الملف الشخصي',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'المفضلة'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'الوصفات'),
      ],
    );
  }
}
