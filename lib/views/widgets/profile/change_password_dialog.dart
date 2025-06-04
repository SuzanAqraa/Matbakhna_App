import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? errorMessage;

  final user = FirebaseAuth.instance.currentUser;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();

    try {
      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPassword,
      );
      await user!.reauthenticateWithCredential(cred);

      if (oldPassword == newPassword) {
        setState(() {
          errorMessage = 'كلمة المرور الجديدة يجب أن تختلف عن القديمة';
          isLoading = false;
        });
        return;
      }

      await user!.updatePassword(newPassword);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'حدث خطأ أثناء التحقق';
      if (e.code == 'wrong-password') {
        message = 'كلمة السر القديمة غير صحيحة';
      } else if (e.code == 'invalid-credential') {
        message = 'بيانات التحقق غير صحيحة. تأكد من كلمة المرور القديمة.';
      } else {
        message = e.message ?? message;
      }
      setState(() {
        errorMessage = message;
        isLoading = false;
      });
    }
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور الجديدة';
    if (value.length < 8) return 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'يجب أن تحتوي على حرف كبير';
    if (!RegExp(r'[!@#\$&*~%^]').hasMatch(value))
      return 'يجب أن تحتوي على رمز مثل @ أو #';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تغيير كلمة المرور'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور القديمة',
              ),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'يرجى إدخال كلمة المرور القديمة'
                          : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور الجديدة',
              ),
              validator: _validateNewPassword,
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : _changePassword,
          child:
              isLoading
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Text('تأكيد'),
        ),
      ],
    );
  }
}
