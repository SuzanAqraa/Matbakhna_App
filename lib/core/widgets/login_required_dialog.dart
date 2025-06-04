import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/views/screens/login_screen.dart';

class LoginRequiredDialog {
  static void show(BuildContext context, Widget destinationPage) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('تنبيه'),
            content: const Text('يجب تسجيل الدخول للوصول إلى هذه الميزة.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                      settings: RouteSettings(
                        arguments:
                            destinationPage, // Send destination as argument
                      ),
                    ),
                  );
                },
                child: const Text('تسجيل الدخول'),
              ),
            ],
          ),
    );
  }
}
