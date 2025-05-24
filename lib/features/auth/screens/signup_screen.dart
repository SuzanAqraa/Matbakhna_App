import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/features/auth/widgets/logo_with_appname.dart';
import '../../../core/utils/brand_colors.dart';
import 'signup_second_screen.dart';
import '../widgets/sign_up_form.dart';

class SignUpStepOnePage extends StatelessWidget {
  const SignUpStepOnePage({super.key});

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
                    onRegistered: (userId) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpStepTwoPage(userId: userId),

                        ),
                      );
                    },
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