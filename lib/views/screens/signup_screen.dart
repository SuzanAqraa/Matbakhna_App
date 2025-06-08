import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/views/widgets/signup/logo_with_appname.dart';
import '../../core/utils/brand_colors.dart';

import 'home_screen.dart';
import '../widgets/signup/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'الرجاء إدخال البريد الإلكتروني';
  }
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(value)) {
    return 'الرجاء إدخال بريد إلكتروني صالح';
  }
  return null;
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.backgroundColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LogoWithName(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: BrandColors.backgroundColor,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SignUpForm(
                    onRegistered: (String userId, String email, String password) async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                          ),
                        ),
                      );

                      if (result == 'back_to_signup') {
                        setState(() {});
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
                  child: const Text(
                    'الذهاب للصفحة الرئيسية بدون إنشاء حساب',
                    style: TextStyle(
                      color: BrandColors.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
