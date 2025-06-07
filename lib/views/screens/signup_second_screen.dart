import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../core/utils/brand_colors.dart';
import '../widgets/signup/singup_add_info.dart';
import 'home_screen.dart';

class SignUpStepTwoPage extends StatefulWidget {
  final String userId;
  const SignUpStepTwoPage({super.key, required this.userId});

  @override
  State<SignUpStepTwoPage> createState() => _SignUpStepTwoPageState();
}

class _SignUpStepTwoPageState extends State<SignUpStepTwoPage> {
  Future<void> _updateUserInfo(String address, String phone) async {
    try {
      final updates = <String, dynamic>{};
      if (address.isNotEmpty) updates['address'] = address;
      if (phone.isNotEmpty) updates['phone'] = phone;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .set(updates, SetOptions(merge: true));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء الحفظ. حاول مرة أخرى.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.backgroundColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: BrandColors.secondaryColor,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'مطبخنا',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: BrandColors.secondaryColor,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: BrandColors.backgroundColor,
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SignUpAdditionalInfoForm(
                        userId: widget.userId,
                        onRegistered: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
