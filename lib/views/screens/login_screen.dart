import 'package:flutter/material.dart';
import '../../controller/login_controller.dart';
import '../../core/utils/brand_colors.dart';
import '../../core/utils/textfeild_styles.dart';
import '../widgets/signup/custom_submit_button.dart';
import '../widgets/signup/custom_input_field.dart'; // تأكد من استيراد الـ widget هنا
import 'home_screen.dart';
import 'signup_screen.dart';
import '../widgets/signup/logo_with_appname.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LoginController _controller = LoginController();

  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  InputBorder _border() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: const BorderSide(color: Colors.black, width: 2),
  );

  TextStyle get _labelStyle => ThemeTextStyle.recipeNameTextFieldStyle;

  Future<void> _login() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final userId = await _controller.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
          (emailErr) => setState(() => _emailError = emailErr),
          (passErr) => setState(() => _passwordError = passErr),
    );

    if (userId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const LogoWithName(),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: BrandColors.backgroundColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomInputField(
                        label: 'البريد الإلكتروني',
                        controller: _emailController,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'example@email.com',
                          border: _border(),
                          enabledBorder: _border(),
                          focusedBorder: _border(),
                          errorText: _emailError,
                        ),
                        validator: _controller.validateEmail,
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        label: 'كلمة السر',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '********',
                          border: _border(),
                          enabledBorder: _border(),
                          focusedBorder: _border(),
                          errorText: _passwordError,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey[700],
                            ),
                            onPressed: () =>
                                setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: _controller.validatePassword,
                      ),
                      const SizedBox(height: 28),
                      CustomSubmitButton(
                        onPressed: _login,
                        label: 'تسجيل الدخول',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('ليس لديك حساب؟'),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'سجل الآن',
                              style: TextStyle(
                                color: BrandColors.secondaryColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                child: const Text(
                  'الذهاب للصفحة الرئيسية بدون تسجيل دخول',
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
      ),
    );
  }
}
