import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/features/auth/screens/profile_screen.dart';

import '../../features/favorites/screens/favorites_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/listing/screens/listing_screen.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesScreen()),
            );            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListingScreen()),
            );            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'الملف الشخصي',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'المفضلة',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'الوصفات',
        ),
      ],
    );
  }
}
