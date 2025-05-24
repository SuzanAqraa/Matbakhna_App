import 'package:flutter/material.dart';
import '../../../../core/utils/brand_colors.dart';

class LogoWithName extends StatelessWidget {
  const LogoWithName({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 16),

        Text(
          'مطبخنا',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: BrandColors.secondaryColor,
            fontFamily: 'Cairo',
          ),
        ),

        SizedBox(height: 28),

        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.image_outlined,
            size: 45,
            color: Colors.grey,
          ),
        ),

        SizedBox(height: 24),
      ],
    );
  }
}