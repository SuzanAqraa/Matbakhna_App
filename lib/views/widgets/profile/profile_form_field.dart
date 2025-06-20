import 'package:flutter/material.dart';
import '../../../core/utils/textfeild_styles.dart';

class ProfileFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool isRequired;
  final FormFieldValidator<String>? validator;
  const ProfileFormField({
    Key? key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.isRequired = true,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        readOnly: readOnly,
        textAlign: TextAlign.right,
        style: ThemeTextStyle.bodySmallTextFieldStyle,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: ThemeTextStyle.recipeNameTextFieldStyle,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14),
          border: const UnderlineInputBorder(),
        ),
        validator: (value) {
          if (validator != null) return validator!(value);

          return null;
        },
      ),
    );
  }
}
