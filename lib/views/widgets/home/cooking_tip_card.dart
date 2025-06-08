import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/utils/brand_colors.dart';
import '../../../core/utils/icon_styles.dart';
import '../../../core/utils/spaces.dart';
import '../../../core/utils/textfeild_styles.dart';

class CookingTipCard extends StatefulWidget {
  final List<String> cookingTips;

  const CookingTipCard({super.key, required this.cookingTips});

  @override
  State<CookingTipCard> createState() => _CookingTipCardState();
}

class _CookingTipCardState extends State<CookingTipCard> {
  int currentTipIndex = 0;
  Timer? _tipTimer;

  @override
  void initState() {
    super.initState();
    if (widget.cookingTips.isNotEmpty) {
      _startTipRotation();
    }
  }

  void _startTipRotation() {
    _tipTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && widget.cookingTips.isNotEmpty) {
        setState(() {
          currentTipIndex = Random().nextInt(widget.cookingTips.length);
        });
      }
    });
  }

  @override
  void dispose() {
    _tipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tips = widget.cookingTips;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 32),
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        decoration: BoxDecoration(
          color: BrandColors.primaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
              size: isSmallScreen ? IconStyle.defaultIconSize : 32,
            ),
            Spaces.horizontalSpacing(isSmallScreen ? 12 : 20),
            Expanded(
              child: tips.isEmpty
                  ? Text(
                      "لا توجد نصائح متاحة حالياً.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? null : 18,
                      ),
                    )
                  : Text(
                      tips[currentTipIndex],
                      style: ThemeTextStyle.bodySmallTextFieldStyle.copyWith(
                        color: Colors.white,
                        fontSize: isSmallScreen ? null : 18,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
