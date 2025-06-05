// sign_up_screen.dart
import 'package:flutter/material.dart';
import '../widgets/signup/sign_up_form.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  void _navigateToNextScreen(BuildContext context, String userId) {
    // TODO: Navigate to the next screen after successful sign-up
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Text(
                'إنشاء حساب',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              SignUpForm(onRegistered: (userId) => _navigateToNextScreen(context, userId)),
            ],
          ),
        ),
      ),
    );
  }
}
