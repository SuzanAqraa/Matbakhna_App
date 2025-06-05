// login_controller.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../repositories/login_repository.dart';

class LoginController {
  final LoginRepository _repository;

  LoginController({LoginRepository? repository})
      : _repository = repository ?? LoginRepository();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال البريد الإلكتروني';
    }
    // يمكنك إضافة تحقق من شكل البريد الإلكتروني هنا إن أردت
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة السر';
    }
    return null;
  }

  Future<String?> login(
      String email, String password, void Function(String?) setEmailError, void Function(String?) setPasswordError) async {
    try {
      final user = await _repository.signInWithEmailAndPassword(email, password);
      return user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setEmailError('هذا البريد غير مسجل');
        setPasswordError(null);
      } else if (e.code == 'wrong-password') {
        setPasswordError('كلمة السر خاطئة');
        setEmailError(null);
      } else {
        setEmailError('فشل تسجيل الدخول. حاول مرة أخرى');
        setPasswordError(null);
      }
    } catch (_) {
      setEmailError('حدث خطأ غير متوقع. يرجى المحاولة لاحقًا.');
    }
    return null;
  }
}
