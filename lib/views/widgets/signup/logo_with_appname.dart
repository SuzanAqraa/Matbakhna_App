import 'package:flutter/material.dart';
import '../../../../core/utils/brand_colors.dart';

class LogoWithName extends StatelessWidget {
  const LogoWithName({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform.translate(
          offset: const Offset(0, -20),
          child: CircleAvatar(
            radius: 90,
            backgroundColor: BrandColors.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Image.network(
                  'https://res.cloudinary.com/dflfjyux4/image/upload/v1748278624/matbakhna_logo_xsasll.png',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
