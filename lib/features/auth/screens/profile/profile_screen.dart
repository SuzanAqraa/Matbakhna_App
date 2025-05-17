import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/brand_colors.dart';
import '../../../../core/widgets/SimpleAppBar.dart';
import '../../../../core/widgets/custom_bottom_navbar.dart';

import 'widgets/avatar_section.dart';
import 'widgets/profile_form_field.dart';
import 'widgets/action_button.dart';
import 'widgets/logout_button.dart';

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

  String? userImageUrl;
  File? userImageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    userImageUrl = 'https://img.freepik.com/premium-vector/avatar-profile-icon-flat-style-female-user-profile-vector-illustration-isolated-background-women-profile-sign-business-concept_157943-38866.jpg?semt=ais_hybrid&w=740';
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        userImageFile = File(pickedFile.path);
        userImageUrl = null; // نعرض الصورة الجديدة من الملف وليس من الانترنت
      });
    }
  }

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
                AvatarSection(
                  hasImage: userImageFile != null || (userImageUrl != null && userImageUrl!.isNotEmpty),
                  imageUrl: userImageFile == null ? userImageUrl : null,
                  imageFile: userImageFile,
                  onEditPressed: _pickImage,
                ),
                const SizedBox(height: 12),
                ProfileFormField(initialValue: name, label: 'الاسم الكامل'),
                ProfileFormField(
                  initialValue: email,
                  label: 'البريد الإلكتروني',
                  keyboardType: TextInputType.emailAddress,
                ),
                ProfileFormField(
                  initialValue: password,
                  label: 'كلمة السر',
                  obscureText: true,
                ),
                ProfileFormField(initialValue: address, label: 'العنوان'),
                ProfileFormField(
                  initialValue: phone,
                  label: 'رقم الهاتف',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15),
                ActionButton(
                  text: 'حفظ',
                  color: BrandColors.primaryColor,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // منطق الحفظ
                    }
                  },
                ),
                const SizedBox(height: 20),
                LogoutButton(
                  onTap: () {
                    // منطق تسجيل الخروج
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavbar(currentIndex: 0),
      ),
    );
  }
}
