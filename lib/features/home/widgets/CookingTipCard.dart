import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CookingTipCard extends StatefulWidget {
  const CookingTipCard({super.key});

  @override
  State<CookingTipCard> createState() => _CookingTipCardState();
}

class _CookingTipCardState extends State<CookingTipCard> {
  final List<String> cookingTips = [
    'الملح شوي شوي عمهلك وبالتدريج وخصوصاً بالطبخات.',
    'سخّن المقلاة قبل ما تحط فيها أي شي.',
    'غسل الخضار قبل التقطيع بيحافظ على قيمتها.',
    'ذوّب الزبدة على نار هادية حتى ما تحترق.',
    'رشة قرفة بتعزز نكهة الحلويات.',
    'خلّي الرز ينقع شوي قبل الطبخ.',
  ];

  int currentTipIndex = 0;
  Timer? _tipTimer;

  @override
  void initState() {
    super.initState();
    _startTipRotation();
  }

  void _startTipRotation() {
    _tipTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        currentTipIndex = Random().nextInt(cookingTips.length);
      });
    });
  }

  @override
  void dispose() {
    _tipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFA5C8A6),
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
            const Icon(Icons.lightbulb_outline, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                cookingTips[currentTipIndex],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
