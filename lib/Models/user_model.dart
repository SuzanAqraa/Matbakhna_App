class UserModel {
  final String username;
  final String email;
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
    return UserModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      avatar: json['avatar'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
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
