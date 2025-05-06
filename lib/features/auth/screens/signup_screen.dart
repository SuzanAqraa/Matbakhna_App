import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  void _showSuccessSnackbar(String message) {
    final colors = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colors.primary,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _registerUser() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    if (_formKey.currentState!.validate()) {
      try {
        // إنشاء الحساب
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final email = _emailController.text.trim();
        final username = email.split('@')[0];
        await credential.user?.sendEmailVerification();
        await FirebaseFirestore.instance.collection('users').doc(credential.user?.uid).set({
          'email': email,
          'username': username,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpStepTwoPage(userId: credential.user?.uid),
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
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final darkBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: colors.onPrimary, width: 1.5),
    );

    TextStyle labelStyle = TextStyle(
      fontSize: 20,
      color: colors.onPrimary,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colors.onPrimary,
                  ),
                ),
                const SizedBox(height: 32),

                // البريد الإلكتروني (إلزامي)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('البريد الإلكتروني *', style: labelStyle),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'example@email.com',
                    border: darkBorder,
                    enabledBorder: darkBorder,
                    focusedBorder: darkBorder,
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

                // كلمة السر (إلزامي)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('كلمة السر *', style: labelStyle),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '********',
                    border: darkBorder,
                    enabledBorder: darkBorder,
                    focusedBorder: darkBorder,
                    errorText: _passwordError,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
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

                // تأكيد كلمة السر (إلزامي)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('تأكيد كلمة السر *', style: labelStyle),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '********',
                    border: darkBorder,
                    enabledBorder: darkBorder,
                    focusedBorder: darkBorder,
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'كلمتا السر غير متطابقتين';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'التالي',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
