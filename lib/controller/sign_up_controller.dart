import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/sign_up_repository.dart';
import '../views/widgets/signup/email_verification_dialog.dart';

class SignUpController {
  final SignUpRepository _repository = SignUpRepository();

  final emailFieldDecoration = const InputDecoration(
    border: OutlineInputBorder(),
    hintText: 'example@mail.com',
  );

  InputDecoration passwordFieldDecoration(bool obscureText,
      VoidCallback toggle,) =>
      InputDecoration(
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
      );

  final confirmPasswordFieldDecoration = const InputDecoration(
    border: OutlineInputBorder(),
  );

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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة السر';
    }
    if (value.length < 6) {
      return 'كلمة السر يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'الرجاء تأكيد كلمة السر';
    }
    if (value != password) {
      return 'كلمتا السر غير متطابقتين';
    }
    return null;
  }

  Future<UserCredential> createUser(String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendEmailVerification(User user) async {
    if (!user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> saveUserData({
    required String uid,
    required Map<String, dynamic> userData,
  }) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set(userData);
  }

  Future<String?> registerUser(BuildContext context,
      String email,
      String password,) async {
    try {
      final credential = await createUser(email, password);
      return credential.user!.uid;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل التسجيل: ${e.toString()}')),
      );
      return null;
    }
  }

  Future<void> saveAdditionalUserInfo(BuildContext context,
      String userId,
      String address,
      String phone,
      String email,
      String password) async { // أضفت email, password هنا

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (!user.emailVerified) {
        await sendEmailVerification(user);

        await user.reload();

        final updatedUser = FirebaseAuth.instance.currentUser;

        final isVerified = await EmailVerificationDialog.show(context, updatedUser!);

        if (!isVerified || !updatedUser.emailVerified) {


          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('saved_email', email);
          await prefs.setString('saved_password', password);

          await updatedUser.delete();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('لم يتم تأكيد البريد الإلكتروني. الحساب لم يُسجَّل.'),
            ),
          );
          throw Exception('لم يتم تأكيد البريد الإلكتروني. الحساب لم يُسجَّل.');
        }
      }

      final username = user.email?.split('@')[0] ?? '';

      await saveUserData(
        uid: userId,
        userData: {
          'username': username,
          'email': user.email ?? '',
          'phone': phone,
          'address': address,
          'avatar': '',
          'createdAt': FieldValue.serverTimestamp(),
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ بيانات الحساب بنجاح!')),
      );
    }
  }

}