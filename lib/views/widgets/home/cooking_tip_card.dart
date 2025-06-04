import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/utils/brand_colors.dart';
import '../../../core/utils/icon_styles.dart';
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
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
            const Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
              size: IconStyle.defaultIconSize,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: tips.isEmpty
                  ? const Text(
                "لا توجد نصائح متاحة حالياً.",
                style: TextStyle(color: Colors.white),
              )
                  : Text(
                tips[currentTipIndex],
                style: ThemeTextStyle.bodySmallTextFieldStyle.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
