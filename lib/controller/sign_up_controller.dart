import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../repositories/sign_up_repository.dart';
import '../views/widgets/signup/email_verification_dialog.dart';

class SignUpController {
  final SignUpRepository _repository = SignUpRepository();

  final emailFieldDecoration = const InputDecoration(
    border: OutlineInputBorder(),
    hintText: 'example@mail.com',
  );

  InputDecoration passwordFieldDecoration(
    bool obscureText,
    VoidCallback toggle,
  ) => InputDecoration(
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

  Future<String?> registerUser(
    BuildContext context,
    String email,
    String password,
    String address,
    String phone,
  ) async {
    try {
      final credential = await _repository.createUser(email, password);
      await _repository.sendEmailVerification(credential.user!);
      final isVerified = await EmailVerificationDialog.show(
        context,
        credential.user!,
      );

      if (isVerified) {
        final username = email.split('@')[0];

        await _repository.saveUserData(
          uid: credential.user!.uid,
          userData: {
            'username': username,
            'email': email,
            'phone': phone,
            'address': address,
            'avatar': '',
          },
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إنشاء الحساب وتفعيله بنجاح!')),
        );

        return credential.user!.uid;
      } else {
        await credential.user!.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لم يتم تأكيد البريد الإلكتروني. الحساب لم يُسجَّل.'),
          ),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل التسجيل: ${e.toString()}')));
      return null;
    }
  }

  Future<String?> getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> saveAdditionalUserInfo(
    String userId,
    String address,
    String phone,
  ) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'address': address,
      'phone': phone,
    }, SetOptions(merge: true));
  }
}
