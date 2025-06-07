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
    await user.sendEmailVerification();
  }

  Future<void> saveUserData({
    required String uid,
    required Map<String, dynamic> userData,
  }) async {
    await _firestore.collection('users').doc(uid).set(userData);
  }
}
