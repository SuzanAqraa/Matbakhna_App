import 'package:flutter/material.dart';
import '../../../core/utils/brand_colors.dart';
import '../../../core/utils/textfeild_styles.dart';

class CustomSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const CustomSubmitButton({
    super.key,
    required this.onPressed,
    this.label = 'انشاء الحساب',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: BrandColors.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(label, style: ThemeTextStyle.ButtonTextFieldStyle),
      ),
    );
  }
}
