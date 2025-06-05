import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:matbakhna_mobile/views/screens/profile_screen.dart';
import 'package:matbakhna_mobile/core/utils/icon_styles.dart';
import 'package:matbakhna_mobile/core/utils/textfeild_styles.dart';

import 'login_required_dialog.dart';

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
        final user = FirebaseAuth.instance.currentUser;

        switch (index) {
          case 0:
            if (user == null) {
              LoginRequiredDialog.show(context,  ProfileScreen());
            } else {
              Navigator.pushNamed(context, '/profile');
            }
            break;
          case 1:
            Navigator.pushNamed(context, '/');
            break;
          case 2:
            Navigator.pushNamed(context, '/favorites');
            break;
          case 3:
            Navigator.pushNamed(context, '/listing', arguments: '');

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
