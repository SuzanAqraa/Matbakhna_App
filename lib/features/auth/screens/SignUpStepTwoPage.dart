import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../home/screens/home_screen.dart';

class SignUpStepTwoPage extends StatefulWidget {
  final String? userId;
  const SignUpStepTwoPage({super.key, this.userId});

  @override
  State<SignUpStepTwoPage> createState() => _SignUpStepTwoPageState();
}

class _SignUpStepTwoPageState extends State<SignUpStepTwoPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _addressError;
  String? _phoneError;

  Future<void> _updateUserInfo() async {
    setState(() {
      _addressError = null;
      _phoneError = null;
    });

    if (!_formKey.currentState!.validate()) return;

    try {
      final Map<String, dynamic> updates = {};

      if (_addressController.text.trim().isNotEmpty) {
        updates['address'] = _addressController.text.trim();
      }
      if (_phoneController.text.trim().isNotEmpty) {
        updates['phone'] = _phoneController.text.trim();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .set(updates, SetOptions(merge: true));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      setState(() {
        _addressError = 'حدث خطأ أثناء الحفظ. حاول مرة أخرى.';
        _phoneError = 'حدث خطأ أثناء الحفظ. حاول مرة أخرى.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFDF5EC);
    const primaryColor = Color(0xFFD37A47);
    const textColor = Colors.black;

    InputBorder getBorder() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: textColor, width: 1.3),
    );

    TextStyle labelStyle = const TextStyle(
      fontSize: 18,
      color: textColor,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'إكمال التسجيل',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 32),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('العنوان (اختياري)', style: labelStyle),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'أدخل عنوانك هنا',
                      border: getBorder(),
                      enabledBorder: getBorder(),
                      focusedBorder: getBorder(),
                      errorText: _addressError,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('رقم الهاتف (اختياري)', style: labelStyle),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'أدخل رقم هاتفك',
                      border: getBorder(),
                      enabledBorder: getBorder(),
                      focusedBorder: getBorder(),
                      errorText: _phoneError,
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty && !RegExp(r'^\d{6,15}$').hasMatch(value)) {
                        return 'الرجاء إدخال رقم هاتف صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updateUserInfo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'حفظ ومتابعة',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                    child: const Text(
                      'تخطي',
                      style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
