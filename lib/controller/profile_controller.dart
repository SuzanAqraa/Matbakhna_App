import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_model.dart';
import '../repositories/profile_repository.dart';

class ProfileController extends ChangeNotifier {
  final UserRepository _userRepository;

  ProfileController(this._userRepository) {
    _init();
  }

  final ImagePicker _picker = ImagePicker();

  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController usernameController;

  String? createdAt;
  String? userImageUrl;
  File? userImageFile;

  bool isLoading = false;

  void _init() {
    emailController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    usernameController = TextEditingController();

    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    isLoading = true;
    notifyListeners();

    final data = await _userRepository.fetchUserProfile();

    if (data != null) {
      final user = UserModel.fromJson(data);

      emailController.text = user.email;
      addressController.text = user.address;
      phoneController.text = user.phone;
      usernameController.text = user.username;
      createdAt = user.createdAt.toString();
      userImageUrl = user.avatar.isNotEmpty
          ? user.avatar
          : 'https://img.freepik.com/premium-vector/avatar-profile-icon-flat-style-female-user-profile-vector-illustration-isolated-background-women-profile-sign-business-concept_157943-38866.jpg?semt=ais_hybrid&w=740';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      userImageFile = File(pickedFile.path);
      userImageUrl = null;
      notifyListeners();
    }
  }

  Future<String?> saveProfile() async {
    final newUsername = usernameController.text.trim();
    final newPhone = phoneController.text.trim();
    final newAddress = addressController.text.trim();

    final data = await _userRepository.fetchUserProfile();

    if (data == null) {
      return 'حدث خطأ، لم يتم تحميل البيانات.';
    }

    final oldUser = UserModel.fromJson(data);

    if (newUsername == oldUser.username &&
        newPhone == oldUser.phone &&
        newAddress == oldUser.address) {
      return 'لا يوجد أي تعديل جديد';
    }

    await _userRepository.updateUserProfile(
      username: newUsername,
      phone: newPhone,
      address: newAddress,
    );

    return 'تم حفظ البيانات بنجاح';
  }

  Future<String?> logout() async {
    try {
      await _userRepository.logout();
      return 'تم تسجيل الخروج بنجاح';
    } catch (e) {
      return 'فشل في تسجيل الخروج: ${e.toString()}';
    }
  }

  void disposeControllers() {
    emailController.dispose();
    addressController.dispose();
    phoneController.dispose();
    usernameController.dispose();
  }
}
