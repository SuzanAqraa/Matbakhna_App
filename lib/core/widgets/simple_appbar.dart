import 'package:flutter/material.dart';
import 'package:matbakhna_mobile/core/utils/brand_colors.dart';
import 'package:matbakhna_mobile/core/utils/icon_styles.dart';
import 'package:matbakhna_mobile/core/utils/textfeild_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AppBar(
        backgroundColor: BrandColors.primaryColor,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: ThemeTextStyle.titleTextFieldStyle,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        leading: showBackButton
            ? IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: IconStyle.defaultIconColor,
            size: IconStyle.defaultIconSize,
          ),
          onPressed: () => Navigator.of(context).pop(),
        )
            : null,
      ),
    );
  }
}
