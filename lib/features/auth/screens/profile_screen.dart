import 'package:flutter/material.dart';
import '../../../core/utils/brand_colors.dart';
import '../../../core/utils/textfeild_styles.dart';
import '../../../core/widgets/custom_bottom_navbar.dart';
import '../../../core/widgets/SimpleAppBar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = 'دانا مرجان';
  String email = 'dana.morgan196@gmail.com';
  String password = '123456';
  String address = 'بديا - شارع المدارس';
  String phone = '0599999999';

  bool hasImage = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: BrandColors.backgroundColor,
        appBar: const CustomAppBar(
          title: 'الملف الشخصي',
          showBackButton: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          hasImage
                              ? const AssetImage('assets/assets/profile.png')
                              : null,
                      child:
                          hasImage
                              ? null
                              : const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () {
                          setState(() {
                            hasImage = !hasImage;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildFormField(initialValue: name, label: 'الاسم الكامل'),
                _buildFormField(
                  initialValue: email,
                  label: 'البريد الإلكتروني',
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildFormField(
                  initialValue: password,
                  label: 'كلمة السر',
                  obscureText: true,
                ),
                _buildFormField(initialValue: address, label: 'العنوان'),
                _buildFormField(
                  initialValue: phone,
                  label: 'رقم الهاتف',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15),
                _buildActionButton('حفظ', BrandColors.primaryColor, () {
                  if (_formKey.currentState!.validate()) {
                    // Save logic
                  }
                }),
                const SizedBox(height: 20),
                _buildLogoutText(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavbar(currentIndex: 0),
      ),
    );
  }

  Widget _buildFormField({
    required String initialValue,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        initialValue: initialValue,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textAlign: TextAlign.right,
        style: ThemeTextStyle.bodySmallTextFieldStyle,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: ThemeTextStyle.recipeNameTextFieldStyle,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 14,
          ),
          border: const UnderlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'هذا الحقل مطلوب';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        text,
        style: ThemeTextStyle.ButtonTextFieldStyle.copyWith(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildLogoutText() {
    return InkWell(
      onTap: () {
        // signout logic
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.logout, size: 20, color: Colors.redAccent),
          const SizedBox(width: 8),
          Text(
            'تسجيل الخروج',
            style: ThemeTextStyle.ButtonTextFieldStyle.copyWith(
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
