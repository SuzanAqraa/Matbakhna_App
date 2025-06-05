import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationDialog extends StatefulWidget {
  final User user;

  const EmailVerificationDialog({super.key, required this.user});

  static Future<bool> show(BuildContext context, User user) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => EmailVerificationDialog(user: user),
    ) ??
        false;
  }

  @override
  State<EmailVerificationDialog> createState() => _EmailVerificationDialogState();
}

class _EmailVerificationDialogState extends State<EmailVerificationDialog> {
  bool _checking = false;

  void _checkVerification() async {
    setState(() => _checking = true);
    await widget.user.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;

    if (refreshedUser != null && refreshedUser.emailVerified) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _checking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لم يتم التحقق بعد. يرجى المحاولة مرة أخرى.')),
      );
    }
  }

  void _resendVerification() async {
    await widget.user.sendEmailVerification();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إعادة إرسال رابط التفعيل.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تفعيل البريد الإلكتروني'),
      content: const Text(
        'تم إرسال رابط تفعيل إلى بريدك الإلكتروني. يرجى تفعيل البريد ثم الضغط على "تم التفعيل".',
      ),
      actions: [
        TextButton(
          onPressed: _checking ? null : _checkVerification,
          child: _checking
              ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('تم التفعيل'),
        ),
        TextButton(
          onPressed: _resendVerification,
          child: const Text('إعادة الإرسال'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('إلغاء'),
        ),
      ],
    );
  }
}
