import 'package:flutter/material.dart';
import '../../../../../core/utils/textfeild_styles.dart';

class ProfileFormField extends StatelessWidget {
  final String initialValue;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;

  const ProfileFormField({
    Key? key,
    required this.initialValue,
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        initialValue: initialValue,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textAlign: TextAlign.right,
        style: ThemeTextStyle.bodySmallTextFieldStyle,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: ThemeTextStyle.recipeNameTextFieldStyle,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14),
          border: const UnderlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'هذا الحقل مطلوب';
          }
          return null;
        },
      ),
    );
  }
}
