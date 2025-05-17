import 'package:flutter/material.dart';
import '../../../core/widgets/custom_bottom_navbar.dart';
import '../../../core/widgets/SimpleAppBar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = 'دانا مرجان';
  String email = 'dana.morgan196@gmail.com';
  String password = '123456';
  String address = 'بديا - شارع المدارس';
  String phone = '0599999999';

  bool isEditing = false;
  bool hasImage = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF6EC),
        appBar: const CustomAppBar(
          title: 'الملف الشخصي',
          showBackButton: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                      hasImage ? const AssetImage('assets/images/profile.png') : null,
                      child: hasImage
                          ? null
                          : const Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () {
                          setState(() {
                            hasImage = !hasImage;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildFormField(
                  initialValue: name,
                  label: 'الاسم الكامل',
                  enabled: isEditing,
                ),
                _buildFormField(
                  initialValue: email,
                  label: 'البريد الإلكتروني',
                  enabled: isEditing,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildFormField(
                  initialValue: password,
                  label: 'كلمة السر',
                  enabled: isEditing,
                  obscureText: true,
                ),
                _buildFormField(
                  initialValue: address,
                  label: 'العنوان',
                  enabled: isEditing,
                ),
                _buildFormField(
                  initialValue: phone,
                  label: 'رقم الهاتف',
                  enabled: isEditing,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton('تعديل', Colors.grey[400]!, () {
                      setState(() {
                        isEditing = !isEditing;
                      });
                    }),
                    const SizedBox(width: 15),
                    _buildActionButton('حفظ', const Color(0xFFA5C8A6), () {
                      if (_formKey.currentState!.validate()) {
                        // save data
                        setState(() {
                          isEditing = false;
                        });
                      }
                    }),
                  ],
                ),
                const SizedBox(height: 30),
                _buildLogoutButton(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavbar(currentIndex: 0),
      ),
    );
  }

  Widget _buildFormField({
    required String initialValue,
    required String label,
    bool enabled = true,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: TextFormField(
        initialValue: initialValue,
        enabled: enabled,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'هذا الحقل مطلوب';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(text),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      onPressed: () {
        //signout logic
      },
      icon: const Icon(Icons.logout),
      label: const Text('تسجيل خروج'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[400],
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
