import 'package:flutter/material.dart';
import '../../../controller/sign_up_controller.dart';
import '../../../core/utils/brand_colors.dart';
import 'custom_input_field.dart';
import 'custom_submit_button.dart';

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomInputField(
              label: 'البريد الإلكتروني *',
              controller: _emailController,
              obscureText: false,
              decoration: _controller.emailFieldDecoration,
              validator: _controller.validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomInputField(
              label: 'كلمة السر *',
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: _controller.passwordFieldDecoration(
                _obscurePassword,
                    () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: _controller.validatePassword,
            ),
            const SizedBox(height: 16),
            CustomInputField(
              label: 'تأكيد كلمة السر *',
              controller: _confirmPasswordController,
              obscureText: _obscurePassword,
              decoration: _controller.confirmPasswordFieldDecoration,
              validator: (value) => _controller.validateConfirmPassword(
                value,
                _passwordController.text,
              ),
            ),
            const SizedBox(height: 28),
            CustomSubmitButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final userId = await _controller.registerUser(
                    context,
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );
                  if (userId != null) {
                    widget.onRegistered(userId);
                    Navigator.pushNamed(context, '/signup_second_screen');
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login_screen');
              },
              child: Text(
                'هل لديك حساب؟ سجل الدخول',
                style: TextStyle(
                  color: BrandColors.secondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
