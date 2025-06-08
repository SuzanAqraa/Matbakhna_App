import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../controller/profile_controller.dart';
import '../../core/utils/brand_colors.dart';
import '../../core/utils/spaces.dart';
import '../../core/validators/profile_field_validators.dart';
import '../../core/widgets/appbar/simple_appbar.dart';
import '../../core/widgets/custom_bottom_navbar.dart';
import '../../repositories/profile_repository.dart';
import '../widgets/profile/avatar_section.dart';
import '../widgets/profile/change_password_dialog.dart';
import '../widgets/profile/profile_form_field.dart';
import '../widgets/profile/action_button.dart';
import '../widgets/profile/logout_button.dart';
import 'home_screen.dart';

Future<T> handleWithRetry<T>({
  required Future<T> Function() request,
  required T fallbackValue,
  int maxRetries = 2,
  Duration retryDelay = const Duration(milliseconds: 300),
}) async {
  int attempts = 0;

  while (attempts < maxRetries) {
    debugPrint('Attempt: ${attempts + 1}');
    try {
      final result = await request();
      debugPrint('Request succeeded on attempt: ${attempts + 1}');
      return result;
    } on SocketException catch (_) {
      debugPrint('SocketException on attempt ${attempts + 1}');
    } on TimeoutException catch (_) {
      debugPrint('TimeoutException on attempt ${attempts + 1}');
    } on FirebaseException catch (_) {
      debugPrint('FirebaseException on attempt ${attempts + 1}');
    } catch (e) {
      debugPrint('Unknown exception on attempt ${attempts + 1}: $e');
    }
    attempts++;
    if (attempts < maxRetries) {
      await Future.delayed(retryDelay);
    }
  }

  debugPrint('All $maxRetries attempts failed. Returning fallback value.');
  return fallbackValue;
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController _controller;
  final _formKey = GlobalKey<FormState>();
  late String originalEmail;

  @override
  void initState() {
    super.initState();
    _controller = ProfileController(UserRepository());
    _controller.addListener(() {
      if (mounted) setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      originalEmail = _controller.emailController.text;
      refreshProfile(); // load with retry
    });
  }

  @override
  void dispose() {
    _controller.disposeControllers();
    _controller.dispose();
    super.dispose();
  }

  Future<void> refreshProfile() async {
    await handleWithRetry<void>(
      request: () => _controller.loadUserProfile(),
      fallbackValue: null,
    );
  }

  void _showEmailVerificationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("تأكيد البريد الإلكتروني"),
        content: const Text("هل تريد إرسال رابط التحقق إلى بريدك الجديد؟"),
        actions: [
          TextButton(
            onPressed: () async {
              final newEmail = _controller.emailController.text.trim();
              if (newEmail.isEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("يرجى إدخال بريد إلكتروني صحيح")),
                );
                return;
              }

              final result = await handleWithRetry<String?>(
                request: () => _controller.updateEmail(newEmail),
                fallbackValue: 'حدث خطأ أثناء تحديث البريد الإلكتروني',
              );

              Navigator.pop(context);

              if (result == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('لم يتم التحقق من البريد الإلكتروني')),
                );
              } else {
                originalEmail = newEmail;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result)),
                );
              }
            },
            child: const Text("تغيير الإيميل"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
        ],
      ),
    );
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
            : RefreshIndicator(
          onRefresh: refreshProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Spaces.verticalSpacing(9),
                  AvatarSection(
                    hasImage: _controller.userImageFile != null ||
                        (_controller.userImageUrl != null &&
                            _controller.userImageUrl!.isNotEmpty),
                    imageUrl: _controller.userImageFile == null
                        ? _controller.userImageUrl
                        : null,
                    imageFile: _controller.userImageFile,
                    onImageChanged: (newUrl) {
                      setState(() {
                        _controller.userImageUrl = newUrl;
                      });
                    },
                  ),
                  Spaces.verticalSpacing(9),
                  ProfileFormField(
                    controller: _controller.usernameController,
                    label: 'اسم المستخدم',
                    isRequired: true,
                    validator: ProfileFieldValidators.validateUsername,
                  ),
                  ProfileFormField(
                    controller: _controller.emailController,
                    label: 'البريد الإلكتروني',
                    keyboardType: TextInputType.emailAddress,
                    isRequired: true,
                    validator: ProfileFieldValidators.validateEmail,
                  ),
                  ElevatedButton(
                    onPressed: _showEmailVerificationDialog,
                    child: const Text('تغيير البريد الإلكتروني'),
                  ),
                  ProfileFormField(
                    controller: _controller.addressController,
                    label: 'العنوان',
                    isRequired: false,
                    validator: ProfileFieldValidators.validateAddress,
                  ),
                  ProfileFormField(
                    controller: _controller.phoneController,
                    label: 'رقم الهاتف',
                    keyboardType: TextInputType.phone,
                    isRequired: false,
                    validator: ProfileFieldValidators.validatePhone,
                  ),
                  Spaces.verticalSpacing(9),
                  ActionButton(
                    text: 'حفظ',
                    color: BrandColors.primaryColor,
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      setState(() => _controller.isLoading = true); // بدء التحميل

                      final result = await handleWithRetry<String?>(
                        request: () => _controller.saveProfile(),
                        fallbackValue: null,
                      );

                      setState(() => _controller.isLoading = false); // إيقاف التحميل

                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('فشل الاتصال بالخادم. تأكد من وجود إنترنت وحاول مرة أخرى.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result)),
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
                  Spaces.verticalSpacing(9),
                  LogoutButton(
                    onTap: () async {
                      final message = await handleWithRetry<String?>(
                        request: () => _controller.logout(),
                        fallbackValue: 'فشل في تسجيل الخروج',
                      );
                      if (message != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor:
                            message.contains('فشل') ? Colors.red : Colors.green,
                          ),
                        );
                        if (message == 'تم تسجيل الخروج بنجاح') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        }
                      }
                    },
                  ),
                  Spaces.verticalSpacing(9),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavbar(currentIndex: 0),
      ),
    );
  }
}
