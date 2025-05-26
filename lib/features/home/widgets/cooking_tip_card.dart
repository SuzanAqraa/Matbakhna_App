import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/utils/brand_colors.dart';
import '../../../core/utils/icon_styles.dart';
import '../../../core/utils/textfeild_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CookingTipCard extends StatefulWidget {
  const CookingTipCard({super.key});

  @override
  State<CookingTipCard> createState() => _CookingTipCardState();
}

class _CookingTipCardState extends State<CookingTipCard> {
  List<String> cookingTips = [];
  int currentTipIndex = 0;
  Timer? _tipTimer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTipsFromFirestore();
  }

  _fetchTipsFromFirestore() async {
    try {
      var querySnapshot =
          await FirebaseFirestore.instance.collection('Tips').get();

      var tips =
          querySnapshot.docs
              .map((doc) {
                var data = doc.data();
                return data['tip']?.toString() ?? '';
              })
              .where((tip) => tip.isNotEmpty)
              .toList();

      setState(() {
        cookingTips = tips;
        currentTipIndex = 0;
        _isLoading = false;
      });

      if (tips.isNotEmpty) {
        _startTipRotation();
      }
    } catch (e) {
      print('Error fetching tips: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startTipRotation() {
    _tipTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && cookingTips.isNotEmpty) {
        setState(() {
          currentTipIndex = Random().nextInt(cookingTips.length);
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
              child:
                  _isLoading
                      ? const Text(
                        "جارٍ تحميل النصائح...",
                        style: TextStyle(color: Colors.white),
                      )
                      : cookingTips.isEmpty
                      ? const Text(
                        "لا توجد نصائح متاحة حالياً.",
                        style: TextStyle(color: Colors.white),
                      )
                      : Text(
                        cookingTips[currentTipIndex],
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
