// sign_up_form.dart
import 'package:flutter/material.dart';
import '../../../controller/sign_up_controller.dart';
import '../../../core/utils/brand_colors.dart';
import '../../../core/utils/textfeild_styles.dart';

import '../../../controller/sign_up_controller.dart';
class SignUpForm extends StatefulWidget {
  final Function(String userId) onRegistered;
  const SignUpForm({super.key, required this.onRegistered});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _controller = SignUpController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text('البريد الإلكتروني *', style: ThemeTextStyle.recipeNameTextFieldStyle),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            decoration: _controller.emailFieldDecoration,
            validator: _controller.validateEmail,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Text('كلمة السر *', style: ThemeTextStyle.recipeNameTextFieldStyle),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: _controller.passwordFieldDecoration(_obscurePassword, () {
              setState(() => _obscurePassword = !_obscurePassword);
            }),
            validator: _controller.validatePassword,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Text('تأكيد كلمة السر *', style: ThemeTextStyle.recipeNameTextFieldStyle),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscurePassword,
            decoration: _controller.confirmPasswordFieldDecoration,
            validator: (value) => _controller.validateConfirmPassword(value, _passwordController.text),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final userId = await _controller.registerUser(
                    context,
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );
                  if (userId != null) widget.onRegistered(userId);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BrandColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text('التالي', style: ThemeTextStyle.ButtonTextFieldStyle),
            ),
          )
        ],
      ),
    );
  }
}
