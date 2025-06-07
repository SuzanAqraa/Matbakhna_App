import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../repositories/profile_repository.dart';

class ProfileController extends ChangeNotifier {
  final UserRepository _userRepository;
  final ImagePicker _picker = ImagePicker();

  ProfileController(this._userRepository) {
    _init();
  }

  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  File? userImageFile;
  String? userImageUrl;
  String? createdAt;

  bool isLoading = false;
  bool isEmailVerified = false;
  bool canEditEmail = true;
  late String originalEmail;

  void _init() {
    emailController = TextEditingController();
    usernameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();

    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    isLoading = true;
    notifyListeners();

    final data = await _userRepository.fetchUserProfile();
    if (data == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    final user = UserModel.fromJson(data);
    final firebaseUser = FirebaseAuth.instance.currentUser;

    final firebaseEmail = firebaseUser?.email ?? '';
    if (firebaseEmail.isNotEmpty && firebaseEmail != user.email) {
      await _userRepository.updateUserEmailInFirestore(firebaseEmail);
      user.email = firebaseEmail;
    }

    emailController.text = user.email;
    usernameController.text = user.username;
    phoneController.text = user.phone ?? '';
    addressController.text = user.address ?? '';
    createdAt = user.createdAt.toString();
    userImageUrl = user.avatar.isNotEmpty
        ? user.avatar
        : 'https://img.freepik.com/premium-vector/avatar-profile-icon-flat-style-female-user-profile-vector-illustration-isolated-background-women-profile-sign-business-concept_157943-38866.jpg?semt=ais_hybrid&w=740';

    originalEmail = user.email;
    isEmailVerified = firebaseUser?.emailVerified ?? false;
    canEditEmail = !isEmailVerified;

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
      final uploadUrl =
      Uri.parse('https://api.cloudinary.com/v1_1/dflfjyux4/image/upload');
      final request = http.MultipartRequest('POST', uploadUrl)
        ..fields['upload_preset'] = 'flutter_unsigned'
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final resStr = await response.stream.bytesToString();
        final json = jsonDecode(resStr);
        return json['secure_url'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> updateEmail(String newEmail) async {
    if (newEmail == originalEmail) {
      return "البريد الإلكتروني جديد، يرجى تغييره.";
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return "المستخدم غير مسجل الدخول";

    try {
      await user.verifyBeforeUpdateEmail(newEmail);

      await _userRepository.updateUserEmailInFirestore(newEmail);

      await FirebaseAuth.instance.signOut();

      return "تم إرسال رابط التحقق إلى بريدك الجديد، يرجى تسجيل الخروج والدخول مجددا بعد التحقق من البريد الالكتروني.";
    } catch (e) {
      return "حدث خطأ أثناء محاولة تغيير البريد الإلكتروني: $e";
    }
  }

  Future<String> saveProfile() async {
    if (emailController.text.trim().isEmpty || !emailController.text.contains('@')) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    if (usernameController.text.trim().isEmpty) {
      return 'يرجى إدخال اسم المستخدم';
    }

    isLoading = true;
    notifyListeners();

    try {
      final data = await _userRepository.fetchUserProfile();
      if (data == null) {
        isLoading = false;
        notifyListeners();
        return 'حدث خطأ، لم يتم تحميل البيانات.';
      }

      final oldUser = UserModel.fromJson(data);
      String? imageUrl = userImageUrl;

      if (userImageFile != null) {
        imageUrl = await _uploadImageToCloudinary(userImageFile!);
        if (imageUrl == null) {
          isLoading = false;
          notifyListeners();
          return 'فشل في رفع الصورة';
        }
      }

      bool isChanged = usernameController.text.trim() != oldUser.username ||
          phoneController.text.trim() != oldUser.phone ||
          addressController.text.trim() != oldUser.address ||
          (userImageFile != null) ||
          (userImageFile == null && imageUrl != oldUser.avatar);

      if (!isChanged) {
        isLoading = false;
        notifyListeners();
        return 'لا يوجد أي تعديل جديد';
      }

      await _userRepository.updateUserProfile(
        username: usernameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        avatar: imageUrl ?? '',
      );

      userImageFile = null;
      userImageUrl = imageUrl;

      isLoading = false;
      notifyListeners();
      return 'تم حفظ البيانات بنجاح';
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return 'حدث خطأ غير متوقع: $e';
    }
  }




  Future<String?> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return "تم تسجيل الخروج بنجاح";
    } catch (e) {
      return "فشل في تسجيل الخروج: $e";
    }
  }

  void disposeControllers() {
    emailController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }
}
