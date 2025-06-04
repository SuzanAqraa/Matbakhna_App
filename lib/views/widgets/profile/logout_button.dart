import 'package:flutter/material.dart';
import '../../../core/utils/textfeild_styles.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.logout, size: 20, color: Colors.redAccent),
          const SizedBox(width: 8),
          Text(
            'تسجيل الخروج',
            style: ThemeTextStyle.ButtonTextFieldStyle.copyWith(
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
