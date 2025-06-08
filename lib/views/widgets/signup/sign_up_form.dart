import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controller/sign_up_controller.dart';
import '../../../core/utils/brand_colors.dart';
import '../../../core/validators/password_validators.dart';
import 'custom_input_field.dart';
import 'custom_submit_button.dart';

class SignUpForm extends StatefulWidget {
  final Function(String userId, String email, String password) onRegistered;

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
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('temp_email');
    final savedPassword = prefs.getString('temp_password');

    if (savedEmail != null) {
      _emailController.text = savedEmail;
    }
    if (savedPassword != null) {
      _passwordController.text = savedPassword;
      _confirmPasswordController.text = savedPassword;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
              hintText: "******",
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: _controller.passwordFieldDecoration(
                _obscurePassword,
                    () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: PasswordValidators.validateNewPassword,
            ),
            const SizedBox(height: 16),
            CustomInputField(
              label: 'تأكيد كلمة السر *',
              hintText: "******",
              controller: _confirmPasswordController,
              obscureText: _obscurePassword,
              decoration: _controller.confirmPasswordFieldDecoration,
              validator: (value) =>
                  PasswordValidators.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
            ),
            const SizedBox(height: 28),
            CustomSubmitButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final result = await _controller.registerAndVerifyUser(
                    context,
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );

                  if (result != null) {
                    widget.onRegistered(
                      result['userId']!,
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );
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
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
