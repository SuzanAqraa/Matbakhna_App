import 'package:firebase_auth/firebase_auth.dart';

User? currentUser = FirebaseAuth.instance.currentUser;

void setupCurrentUserListener() {
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    currentUser = user;
  });
}
