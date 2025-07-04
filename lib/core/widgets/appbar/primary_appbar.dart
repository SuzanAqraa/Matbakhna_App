import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/views/screens/filter_screen.dart';
import 'package:matbakhna_mobile/core/utils/brand_colors.dart';
import 'package:matbakhna_mobile/core/utils/icon_styles.dart';
import 'package:matbakhna_mobile/core/utils/textfeild_styles.dart';

class HomeAppBar extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const HomeAppBar({
    super.key,
    required this.title,
    this.controller,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController effectiveController = controller ?? TextEditingController();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 32),
      decoration: const BoxDecoration(
        color: BrandColors.primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(100)),
      ),
      child: Column(
        children: [
          Text(title, style: ThemeTextStyle.titleTextFieldStyle),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: BrandColors.secondaryBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: effectiveController,
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                      style: ThemeTextStyle.recipeNameTextFieldStyle,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.search,
                            color: IconStyle.defaultIconColor,
                            size: IconStyle.defaultIconSize),
                        hintText: 'ابحث عن وصفة...',
                        hintStyle: ThemeTextStyle.interActionTextFieldStyle,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/filter');
                  },
                  icon: const Icon(Icons.tune,
                      color: IconStyle.defaultIconColor,
                      size: IconStyle.defaultIconSize),
                  label: Text('عذوقك', style: ThemeTextStyle.interActionTextFieldStyle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrandColors.secondaryBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    elevation: 2,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
