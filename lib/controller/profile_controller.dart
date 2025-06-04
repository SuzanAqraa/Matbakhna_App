import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import '../repositories/profile_repository.dart';

class ProfileController extends ChangeNotifier {
  final UserRepository _userRepository;
  final ImagePicker _picker = ImagePicker();

  ProfileController(this._userRepository) {
    _init();
  }

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

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    try {
      final uploadUrl = Uri.parse('https://api.cloudinary.com/v1_1/dflfjyux4/image/upload');
      final request = http.MultipartRequest('POST', uploadUrl)
        ..fields['upload_preset'] = 'flutter_unsigned'
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final data = json.decode(res.body);
        return data['secure_url'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
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

    String? imageUrl = userImageUrl;
    if (userImageFile != null) {
      imageUrl = await _uploadImageToCloudinary(userImageFile!);
      if (imageUrl == null) {
        return 'فشل في رفع الصورة';
      }
    }

    bool isChanged = newUsername != oldUser.username ||
        newPhone != oldUser.phone ||
        newAddress != oldUser.address ||
        (userImageFile != null) ||
        (userImageFile == null && imageUrl != oldUser.avatar);

    if (!isChanged) {
      return 'لا يوجد أي تعديل جديد';
    }

    await _userRepository.updateUserProfile(
      username: newUsername,
      phone: newPhone,
      address: newAddress,
      avatar: imageUrl,
    );

    userImageFile = null;
    userImageUrl = imageUrl;

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
