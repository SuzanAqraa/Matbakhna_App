import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final InputDecoration decoration;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? hintText;

  const CustomInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.obscureText,
    required this.decoration,
    required this.validator,
    this.keyboardType,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final inputDecoration = decoration.copyWith(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black87, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black87, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black, width: 3),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: inputDecoration,
          validator: validator,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
