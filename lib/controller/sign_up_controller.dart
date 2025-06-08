import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/user_model.dart';
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

  Future<Map<String, String>?> registerAndVerifyUser(
      BuildContext context,
      String email,
      String password,
      ) async {
    try {
      final credential = await createUser(email, password);
      final user = credential.user;

      if (user != null) {
        await sendEmailVerification(user);

        final isVerified = await EmailVerificationDialog.show(context, user);

        await user.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;

        if (!isVerified || !(refreshedUser?.emailVerified ?? false)) {
          await refreshedUser?.delete();
          await FirebaseAuth.instance.signOut();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('لم يتم تأكيد البريد الإلكتروني. لم يتم إنشاء الحساب.'),
            ),
          );
          return null;
        }


        final username = email.split('@').first;


        final userModel = UserModel(
          username: username,
          email: email,
          avatar: '',
            phone :'',
            address: '',
          createdAt: DateTime.now(),
        );


        await saveUserData(
          uid: user.uid,
          userData: userModel.toJson(),
        );

        return {'userId': user.uid};
      }

      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل التسجيل: ${e.toString()}')),
      );
      return null;
    }
  }



}