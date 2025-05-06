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
      // يمكن تخصيص مزيد من الأخطاء حسب الحاجة
      setState(() {
        _addressError = 'حدث خطأ أثناء الحفظ. حاول مرة أخرى.';
        _phoneError = 'حدث خطأ أثناء الحفظ. حاول مرة أخرى.';
      });
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
                  'إكمال التسجيل',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colors.onPrimary,
                  ),
                ),
                const SizedBox(height: 32),

                // العنوان
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('العنوان (اختياري)', style: labelStyle),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: 'أدخل عنوانك هنا',
                    border: darkBorder,
                    enabledBorder: darkBorder,
                    focusedBorder: darkBorder,
                    errorText: _addressError,
                  ),
                ),
                const SizedBox(height: 16),

                // الهاتف
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
                    border: darkBorder,
                    enabledBorder: darkBorder,
                    focusedBorder: darkBorder,
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

                // زر الحفظ
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateUserInfo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'حفظ ومتابعة',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                // زر تخطي
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: const Text('تخطي'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
