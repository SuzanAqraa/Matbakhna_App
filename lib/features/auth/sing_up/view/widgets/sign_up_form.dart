import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../core/utils/brand_colors.dart';
import '../../../../../../core/utils/textfeild_styles.dart';
import 'package:matbakhna_mobile/features/auth/sing_up/view/screens/login_screen.dart';

class SignUpForm extends StatefulWidget {
  final Function(String userId) onRegistered;

  const SignUpForm({super.key, required this.onRegistered});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
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
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final email = _emailController.text.trim();
      final username = email.split('@')[0];
      final avatarUrl = 'https://ui-avatars.com/api/?name=$username&background=random';

      await credential.user!.sendEmailVerification();

      await FirebaseFirestore.instance.collection('users').doc(credential.user?.uid).set({
        'email': email,
        'username': username,
        'avatar': avatarUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      widget.onRegistered(credential.user!.uid);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال رابط تفعيل إلى بريدك الإلكتروني')),
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
    return SingleChildScrollView(
      child: Column(
        children: [

          const SizedBox(height: 32),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('البريد الإلكتروني *', style: _labelStyle),
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
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
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
                    obscuringCharacter: '●',
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: '********',
                      border: _border(),
                      enabledBorder: _border(),
                      focusedBorder: _border(),
                      errorText: _passwordError,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey[700],
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'الرجاء إدخال كلمة السر';
                      if (value.length < 8) return 'كلمة السر يجب أن تكون على الأقل 8 أحرف';

                      final hasUppercase = value.contains(RegExp(r'[A-Z]'));
                      final hasLowercase = value.contains(RegExp(r'[a-z]'));
                      final hasDigit = value.contains(RegExp(r'\d'));
                      final hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

                      if (!hasUppercase) return 'كلمة السر يجب أن تحتوي على حرف كبير';
                      if (!hasLowercase) return 'كلمة السر يجب أن تحتوي على حرف صغير';
                      if (!hasDigit) return 'كلمة السر يجب أن تحتوي على رقم';
                      if (!hasSpecialChar) return 'كلمة السر يجب أن تحتوي على رمز خاص';

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
                    obscuringCharacter: '●',
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.visiblePassword,
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
                        backgroundColor: BrandColors.primaryColor,
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('هل لديك حساب بالفعل؟'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          'سجل الدخول',
                          style: TextStyle(
                            color: Color(0xFFE56B50),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}