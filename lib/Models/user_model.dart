import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username;
  late final String email;
  final String phone;
  final String address;
  final String avatar;
  final DateTime createdAt;

  UserModel({
    required this.username,
    required this.email,
    required this.phone,
    required this.address,
    required this.avatar,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;

    if (json['createdAt'] is Timestamp) {
      parsedDate = (json['createdAt'] as Timestamp).toDate();
    } else if (json['createdAt'] is String) {
      parsedDate = DateTime.tryParse(json['createdAt']) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return UserModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      avatar: json['avatar'] ?? '',
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'address': address,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
