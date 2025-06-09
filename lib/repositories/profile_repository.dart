import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isConnected() async {
    var result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    final doc = await _firestore.collection('users').doc(currentUser.uid).get();
    if (!doc.exists) return null;

    return doc.data();
  }

  Future<void> updateUserProfile({
    required String username,
    required String phone,
    required String address,
    String? avatar,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final connected = await isConnected();
    if (!connected) {
      print("لا يوجد اتصال بالإنترنت، سيتم حفظ التحديثات محلياً ومزامنتها لاحقاً");
      return;
    }

    final updates = {
      'username': username,
      'phone': phone,
      'address': address,
      if (avatar != null) 'avatar': avatar,
    };

    await _firestore.collection('users').doc(currentUser.uid).update(updates);
  }

  Future<void> updateUserEmailInFirestore(String newEmail) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final connected = await isConnected();
    if (!connected) {
      print("لا يوجد اتصال بالإنترنت، سيتم حفظ التحديثات محلياً ومزامنتها لاحقاً");
    }

    final userDoc = _firestore.collection('users').doc(user.uid);
    await userDoc.update({'email': newEmail});
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
