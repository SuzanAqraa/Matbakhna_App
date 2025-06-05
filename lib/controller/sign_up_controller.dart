import 'package:flutter/material.dart';
import '../repositories/sign_up_repository.dart';


class SignUpController {
  final SignUpRepository _repository = SignUpRepository();

  // ديكور حقل البريد الإلكتروني
  InputDecoration get emailFieldDecoration => InputDecoration(
    hintText: 'example@email.com',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Colors.black, width: 2)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Colors.black, width: 2)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Colors.black, width: 2)),
  );

  // ديكور حقل كلمة المرور مع زر اظهار/اخفاء
  InputDecoration passwordFieldDecoration(bool obscure, VoidCallback toggleObscure) => InputDecoration(
    hintText: '********',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Colors.black, width: 2)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Colors.black, width: 2)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Colors.black, width: 2)),
    suffixIcon: IconButton(
      icon: Icon(obscure ? Icons.visibility : Icons.visibility_off, color: Colors.grey[700]),
      onPressed: toggleObscure,
    ),
  );

  // ديكور حقل تأكيد كلمة المرور
  InputDecoration get confirmPasswordFieldDecoration => InputDecoration(
    hintText: '********',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Colors.black, width: 2)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Colors.black, width: 2)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Colors.black, width: 2)),
  );

  // دوال التحقق
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'الرجاء إدخال البريد الإلكتروني';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'صيغة البريد الإلكتروني غير صحيحة';
    return null;
  }

  String? validatePassword(String? value) {
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
  }

  String? validateConfirmPassword(String? value, String password) {
    if (value != password) return 'كلمتا السر غير متطابقتين';
    return null;
  }

  // دالة التسجيل التي تستخدم الريبو
  Future<String?> registerUser(BuildContext context, String email, String password) async {
    try {
      final credential = await _repository.createUser(email, password);

      final username = email.split('@')[0];
      final avatarUrl = 'https://ui-avatars.com/api/?name=$username&background=random';

      await _repository.sendEmailVerification(credential.user!);

      await _repository.saveUserData(credential.user!.uid, email);

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('تفعيل البريد الإلكتروني'),
            content: const Text('تم إرسال رابط تفعيل إلى بريدك الإلكتروني. يرجى تفعيل البريد ثم الضغط على "تم التفعيل".'),
            actions: [
              TextButton(
                onPressed: () async {
                  await credential.user!.reload();
                  final refreshedUser = credential.user;
                  if (refreshedUser != null && refreshedUser.emailVerified) {
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('لم يتم التحقق بعد. تأكد من أنك قمت بتفعيل البريد.')),
                    );
                  }
                },
                child: const Text('تم التفعيل'),
              ),
              TextButton(
                onPressed: () async {
                  await _repository.resendVerificationEmail();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إعادة إرسال رابط التفعيل.')),
                  );
                },
                child: const Text('إعادة الإرسال'),
              ),
            ],
          );
        },
      );

      return credential.user?.uid;
    } catch (e) {
      // هنا يمكنك إضافة معالجة أخطاء خاصة بالواجهة أو إظهار رسائل
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء التسجيل: $e')));
      return null;
    }
  }
}
