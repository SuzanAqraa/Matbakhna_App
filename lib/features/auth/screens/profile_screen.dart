import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/core/widgets/custom_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA5C8A6),
        title: const Text('الشخصية'),
        centerTitle: true,
        automaticallyImplyLeading: false,  // إزالة زر الرجوع
      ),
      body: Center(
        child: Text('معلومات الشخصية ستكون هنا'),
      ),
      bottomNavigationBar: BottomNavbar(  // استدعاء الـ BottomNavbar هنا
        currentIndex: 0,  // تحديد أي أيقونة نشطة (في هذه الحالة "الشخصية")
        onTap: (index) {
          // هنا تضع منطق التنقل بين الصفحات
          if (index == 2) {
            Navigator.pushNamed(context, '/favorites');  // تغيير المسار حسب احتياجك
          } else if (index == 1) {
            Navigator.pushNamed(context, '/home');  // تغيير المسار حسب احتياجك
          }
        },
      ),
    );
  }
}
