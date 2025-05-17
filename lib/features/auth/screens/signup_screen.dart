import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/utils/brand_colors.dart';
import '../../../core/utils/textfeild_styles.dart';
import 'SignUpStepTwoPage.dart';

class SignUpStepOnePage extends StatefulWidget {
  const SignUpStepOnePage({super.key});

  @override
  State<SignUpStepOnePage> createState() => _SignUpStepOnePageState();
}

class _SignUpStepOnePageState extends State<SignUpStepOnePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  InputBorder _border() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: const BorderSide(color: Colors.black, width: 2),
  );

  TextStyle get _labelStyle => ThemeTextStyle.recipeNameTextFieldStyle;

  Future<void> _registerUser() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    if (!_formKey.currentState!.validate()) return;

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      final email = _emailController.text.trim();
      final username = email.split('@')[0];

      await credential.user?.sendEmailVerification();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user?.uid)
          .set({'email': email, 'username': username});

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SignUpStepTwoPage(userId: credential.user?.uid),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          _emailError = 'هذا البريد مستخدم بالفعل';
        } else if (e.code == 'weak-password') {
          _passwordError = 'كلمة السر ضعيفة';
        } else if (e.code == 'invalid-email') {
          _emailError = 'صيغة البريد الإلكتروني غير صحيحة';
        } else {
          _emailError = 'حدث خطأ: ${e.message}';
        }
      });
    }
  }

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
                const SizedBox(height: 16),

                const Text(
                  'مطبخنا',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: BrandColors.secondaryColor,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 28),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: BrandColors.backgroundColor,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.image_outlined,
                            size: 45,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'البريد الإلكتروني *',
                            style: _labelStyle,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'example@email.com',
                            border: _border(),
                            enabledBorder: _border(),
                            focusedBorder: _border(),
                            errorText: _emailError,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegex.hasMatch(value)) {
                              return 'صيغة البريد الإلكتروني غير صحيحة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('كلمة السر *', style: _labelStyle),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: '********',
                            border: _border(),
                            enabledBorder: _border(),
                            focusedBorder: _border(),
                            errorText: _passwordError,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey[700],
                              ),
                              onPressed:
                                  () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال كلمة السر';
                            }
                            if (value.length < 6) {
                              return 'كلمة السر يجب أن تكون على الأقل 6 أحرف';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('تأكيد كلمة السر *', style: _labelStyle),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: '********',
                            border: _border(),
                            enabledBorder: _border(),
                            focusedBorder: _border(),
                          ),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'كلمتا السر غير متطابقتين';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: BrandColors.secondaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              'التالي',
                              style: ThemeTextStyle.ButtonTextFieldStyle,
                            ),
                          ),
                        ),
                      ],
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
