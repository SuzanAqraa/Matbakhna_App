import 'package:firebase_auth/firebase_auth.dart';
import '../core/utils/error_msg.dart';

class ChangePasswordController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return Constants.errorUserNotLoggedIn;

    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(cred);

      if (oldPassword == newPassword) {
        return Constants.errorSamePassword;
      }

      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return Constants.errorOldPasswordIncorrect;
      } else if (e.code == 'invalid-credential') {
        return Constants.errorInvalidCredential;
      }
      return e.message ?? Constants.errorUnexpected;
    } catch (e) {
      return Constants.errorUnexpected;
    }
  }
}
