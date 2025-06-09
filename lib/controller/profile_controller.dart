import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matbakhna_mobile/Models/user_model.dart';

import '../core/utils/constants.dart';

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
        : Constants.defaultAvatarUrl;

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
      final uploadUrl = Uri.parse(Constants.cloudinaryUploadUrl);
      final request = http.MultipartRequest('POST', uploadUrl)
        ..fields['upload_preset'] = Constants.cloudinaryUploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final resStr = await response.stream.bytesToString();
        final json = jsonDecode(resStr);
        return json['secure_url'];
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  Future<String?> updateEmail(String newEmail) async {
    if (newEmail == originalEmail) {
      return Constants.errorEmailSame;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Constants.errorNotLoggedIn;

    try {
      await user.verifyBeforeUpdateEmail(newEmail);
      await _userRepository.updateUserEmailInFirestore(newEmail);
      await FirebaseAuth.instance.signOut();

      return Constants.successEmailVerificationSent;
    } catch (e) {
      return '${Constants.errorEmailChange}$e';
    }
  }

  Future<String> saveProfile() async {
    if (emailController.text.trim().isEmpty || !emailController.text.contains('@')) {
      return Constants.errorInvalidEmail;
    }
    if (usernameController.text.trim().isEmpty) {
      return Constants.errorEmptyUsername;
    }

    isLoading = true;
    notifyListeners();

    try {
      final data = await _userRepository.fetchUserProfile();
      if (data == null) {
        isLoading = false;
        notifyListeners();
        return Constants.errorProfileNotLoaded;
      }

      final oldUser = UserModel.fromJson(data);
      String? imageUrl = userImageUrl;

      if (userImageFile != null) {
        imageUrl = await _uploadImageToCloudinary(userImageFile!);
        if (imageUrl == null) {
          isLoading = false;
          notifyListeners();
          return Constants.errorImageUpload;
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
        return Constants.errorNoChanges;
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
      return Constants.successProfileSaved;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return 'حدث خطأ غير متوقع: $e';
    }
  }

  Future<String?> logout() async {
    try {
      await _userRepository.logout();
      return Constants.successLogout;
    } catch (e) {
      return '${Constants.errorLogout}$e';
    }
  }

  void disposeControllers() {
    emailController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }
}
