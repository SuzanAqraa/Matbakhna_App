import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> createUser(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendEmailVerification(User user) async {
    if (!user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> resendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  bool isEmailVerified() {
    return _auth.currentUser?.emailVerified ?? false;
  }

  Future<void> saveUserData({
    required String uid,
    required Map<String, dynamic> userData,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      ...userData,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
