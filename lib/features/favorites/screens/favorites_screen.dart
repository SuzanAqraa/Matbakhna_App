import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/core/widgets/custom_widgets.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA5C8A6),
        title: const Text('المحفوظات'),
        centerTitle: true,
        automaticallyImplyLeading: false,  // إزالة زر الرجوع
      ),
      body: Center(
        child: Text('المحفوظات ستكون هنا'),
      ),
      bottomNavigationBar: BottomNavbar(  // استدعاء الـ BottomNavbar هنا
        currentIndex: 2,  // تحديد أي أيقونة نشطة (في هذه الحالة "المحفوظات")
        onTap: (index) {
          // هنا تضع منطق التنقل بين الصفحات
          if (index == 1) {
            Navigator.pushNamed(context, '/home');  // تغيير المسار حسب احتياجك
          } else if (index == 0) {
            Navigator.pushNamed(context, '/profile');  // تغيير المسار حسب احتياجك
          }
        },
      ),
    );
  }
}
