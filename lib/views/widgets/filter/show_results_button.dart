import 'package:flutter/material.dart';
import '../../../core/utils/brand_colors.dart';
import '../../../core/utils/textfeild_styles.dart';


class ShowResultsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ShowResultsButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: BrandColors.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        'أظهر النتائج',
        style: ThemeTextStyle.ButtonTextFieldStyle.copyWith(color: Colors.black),
      ),
    );
  }
}
