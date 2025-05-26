import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/utils/brand_colors.dart';
import '../../../../core/widgets/SimpleAppBar.dart';
import '../../../../core/widgets/custom_bottom_navbar.dart';

import '../../../home/screens/home_screen.dart';
import '../widgets/avatar_section.dart';
import '../widgets/change_password_dialog.dart';
import '../widgets/profile_form_field.dart';
import '../widgets/action_button.dart';
import '../widgets/logout_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String? createdAt;
  String? userImageUrl;
  File? userImageFile;
  final ImagePicker _picker = ImagePicker();

  final User? currentUser = FirebaseAuth.instance.currentUser;

  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    usernameController = TextEditingController();

    _loadUserProfile();
  }

  @override
  void dispose() {
    emailController.dispose();
    addressController.dispose();
    phoneController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    if (currentUser != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      final data = doc.data();
      if (data != null) {
        setState(() {
          emailController.text = data['email'] ?? '';
          addressController.text = data['address'] ?? '';
          phoneController.text = data['phone'] ?? '';
          usernameController.text = data['username'] ?? '';
          createdAt = data['createdAt']?.toDate().toString();
          userImageUrl =
              data['avatar'] ??
              'https://img.freepik.com/premium-vector/avatar-profile-icon-flat-style-female-user-profile-vector-illustration-isolated-background-women-profile-sign-business-concept_157943-38866.jpg?semt=ais_hybrid&w=740';
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        userImageFile = File(pickedFile.path);
        userImageUrl = null;
      });
    }
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (currentUser != null) {
      final docRef =
      FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);
      final currentData = await docRef.get();
      final data = currentData.data();

      final newUsername = usernameController.text.trim();
      final newPhone = phoneController.text.trim();
      final newAddress = addressController.text.trim();

      final oldUsername = data?['username']?.trim() ?? '';
      final oldPhone = data?['phone']?.trim() ?? '';
      final oldAddress = data?['address']?.trim() ?? '';

      if (newUsername == oldUsername &&
          newPhone == oldPhone &&
          newAddress == oldAddress) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يوجد أي تعديل جديد')),
        );
        return;
      }

      await docRef.update({
        'username': newUsername,
        'phone': newPhone,
        'address': newAddress,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ البيانات بنجاح')),
      );
    }
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تسجيل الخروج بنجاح'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في تسجيل الخروج: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
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
                  hasImage: userImageFile != null ||
                      (userImageUrl != null && userImageUrl!.isNotEmpty),
                  imageUrl: userImageFile == null ? userImageUrl : null,
                  imageFile: userImageFile,
                  onEditPressed: _pickImage,
                ),
                const SizedBox(height: 12),
                ProfileFormField(
                  controller: usernameController,
                  label: 'اسم المستخدم',
                  isRequired: true,
                ),
                ProfileFormField(
                  controller: emailController,
                  label: 'البريد الإلكتروني',
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  isRequired: true,
                ),
                ProfileFormField(
                  controller: addressController,
                  label: 'العنوان',
                  isRequired: false,
                ),
                ProfileFormField(
                  controller: phoneController,
                  label: 'رقم الهاتف',
                  keyboardType: TextInputType.phone,
                  isRequired: false,
                ),
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
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 20),
                LogoutButton(onTap: _logout),
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
