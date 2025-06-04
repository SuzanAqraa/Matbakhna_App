import 'package:flutter/material.dart';
import '../../controller/profile_controller.dart';
import '../../core/utils/brand_colors.dart';
import '../../core/utils/spaces.dart';
import '../../core/widgets/appbar/simple_appbar.dart';
import '../../core/widgets/custom_bottom_navbar.dart';

import '../../repositories/profile_repository.dart';
import '../widgets/profile/avatar_section.dart';
import '../widgets/profile/change_password_dialog.dart';
import '../widgets/profile/profile_form_field.dart';
import '../widgets/profile/action_button.dart';
import '../widgets/profile/logout_button.dart';

import 'home_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = ProfileController(UserRepository());
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.disposeControllers();
    _controller.dispose();
    super.dispose();
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
        body: _controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Spaces.verticalSpacing(12),

                AvatarSection(
                  hasImage: _controller.userImageFile != null ||
                      (_controller.userImageUrl != null &&
                          _controller.userImageUrl!.isNotEmpty),
                  imageUrl: _controller.userImageFile == null
                      ? _controller.userImageUrl
                      : null,
                  imageFile: _controller.userImageFile,
                ),

                Spaces.verticalSpacing(12),
                ProfileFormField(
                  controller: _controller.usernameController,
                  label: 'اسم المستخدم',
                  isRequired: true,
                ),
                ProfileFormField(
                  controller: _controller.emailController,
                  label: 'البريد الإلكتروني',
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  isRequired: true,
                ),
                ProfileFormField(
                  controller: _controller.addressController,
                  label: 'العنوان',
                  isRequired: false,
                ),
                ProfileFormField(
                  controller: _controller.phoneController,
                  label: 'رقم الهاتف',
                  keyboardType: TextInputType.phone,
                  isRequired: false,
                ),
                Spaces.verticalSpacing(20),
                ActionButton(
                  text: 'حفظ',
                  color: BrandColors.primaryColor,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final message = await _controller.saveProfile();
                    if (message != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const ChangePasswordDialog(),
                    );
                  },
                  child: const Text(
                    'تغيير كلمة المرور',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Spaces.verticalSpacing(20),
                LogoutButton(
                  onTap: () async {
                    final message = await _controller.logout();
                    if (message != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          backgroundColor: message.contains('فشل')
                              ? Colors.red
                              : Colors.green,
                        ),
                      );
                      if (message == 'تم تسجيل الخروج بنجاح') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomePage()),
                        );
                      }
                    }
                  },
                ),
                Spaces.verticalSpacing(20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavbar(currentIndex: 0),
      ),
    );
  }
}
