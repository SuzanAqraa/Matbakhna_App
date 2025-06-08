import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../controller/profile_controller.dart';
import '../../core/utils/brand_colors.dart';
import '../../core/utils/network_helpers/network_utils.dart';
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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController _controller;
  final _formKey = GlobalKey<FormState>();

  late String _originalEmail;
  late String _originalUsername;
  late String _originalAddress;
  late String _originalPhone;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = ProfileController(UserRepository());
    _controller.addListener(_refresh);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _controller.disposeControllers();
    _controller.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _initialize() async {
    await _loadProfile();

    _originalEmail = _controller.emailController.text.trim();
    _originalUsername = _controller.usernameController.text.trim();
    _originalAddress = _controller.addressController.text.trim();
    _originalPhone = _controller.phoneController.text.trim();

    _isInitialized = true;
    if (mounted) setState(() {});
  }

  Future<void> _loadProfile() async {
    await handleWithRetry<void>(
      request: _controller.loadUserProfile,
      maxRetries: 3,
      fallbackValue: null,
      retryDelay: const Duration(seconds: 2),
    );
  }

  bool _hasChanges() {
    return _controller.emailController.text.trim() != _originalEmail ||
        _controller.usernameController.text.trim() != _originalUsername ||
        _controller.addressController.text.trim() != _originalAddress ||
        _controller.phoneController.text.trim() != _originalPhone;
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
              Navigator.pop(context);

              if (newEmail.isEmpty) {
                _showSnackBar("يرجى إدخال بريد إلكتروني صحيح");
                return;
              }

              final result = await handleWithRetry<String?>(
                request: () => _controller.updateEmail(newEmail),
                maxRetries: 3,
                fallbackValue: null,
                retryDelay: const Duration(seconds: 2),
              );

              if (result != null) {
                _originalEmail = newEmail;
                _showSnackBar(result);
              } else {
                _showSnackBar('لم يتم التحقق من البريد الإلكتروني');
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

  void _showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_hasChanges()) {
      _showSnackBar("لم تقم بتعديل أي بيانات للحفظ.");
      return;
    }

    setState(() => _controller.isLoading = true);

    try {
      final result = await handleWithRetry<String?>(
        request: _controller.saveProfile,
        maxRetries: 2,
        fallbackValue: null,
        retryDelay: const Duration(seconds: 2),
        onFail: () {
          _showSnackBar(
            "تعذر حفظ البيانات. سيتم حفظها عند عودة الاتصال.",
          );

        },
      );

      if (result != null) {
        _originalEmail = _controller.emailController.text.trim();
        _originalUsername = _controller.usernameController.text.trim();
        _originalAddress = _controller.addressController.text.trim();
        _originalPhone = _controller.phoneController.text.trim();

        _showSnackBar(result);
      } else {
        _showSnackBar(
          'فشل الاتصال بالخادم. تأكد من وجود إنترنت وحاول مرة أخرى.',
          backgroundColor: Colors.red,
        );
      }
    } on SocketException {
      _showSnackBar(
        'فشل الاتصال بالإنترنت. سيتم حفظ التعديلات عند عودة الاتصال.',
        backgroundColor: Colors.red,
      );
    } on FirebaseException catch (e) {
      _showSnackBar(
        e.code == 'network-request-failed'
            ? 'فشل الاتصال بخدمات Firebase. تحقق من اتصالك بالإنترنت.'
            : 'حدث خطأ في Firebase: ${e.message}',
        backgroundColor: Colors.red,
      );
    } catch (e) {
      _showSnackBar('حدث خطأ غير متوقع: $e', backgroundColor: Colors.red);
    } finally {
      if (mounted) setState(() => _controller.isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    final message = await handleWithRetry<String?>(
      request: _controller.logout,
      maxRetries: 3,
      fallbackValue: null,
      retryDelay: const Duration(seconds: 2),
    );

    if (message != null) {
      _showSnackBar(
        message,
        backgroundColor: message.contains('فشل') ? Colors.red : Colors.green,
      );
      if (message == 'تم تسجيل الخروج بنجاح') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: BrandColors.backgroundColor,
        appBar: const CustomAppBar(title: 'الملف الشخصي', showBackButton: false),
        body: _controller.isLoading && !_isInitialized
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: _loadProfile,
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
                        (_controller.userImageUrl?.isNotEmpty ?? false),
                    imageUrl: _controller.userImageFile == null
                        ? _controller.userImageUrl
                        : null,
                    imageFile: _controller.userImageFile,
                    onImageChanged: (url) =>
                        setState(() => _controller.userImageUrl = url),
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
                    onPressed: _saveProfile,
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
                  LogoutButton(onTap: _handleLogout),
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
