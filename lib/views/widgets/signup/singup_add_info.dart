import 'package:flutter/material.dart';
import '../../../controller/sign_up_controller.dart';
import '../../../core/utils/textfeild_styles.dart';
import 'custom_submit_button.dart';

class SignUpAdditionalInfoForm extends StatefulWidget {
  final String userId;
  final VoidCallback onRegistered;

  const SignUpAdditionalInfoForm({
    super.key,
    required this.userId,
    required this.onRegistered,
  });

  @override
  State<SignUpAdditionalInfoForm> createState() =>
      _SignUpAdditionalInfoFormState();
}

class _SignUpAdditionalInfoFormState extends State<SignUpAdditionalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _controller = SignUpController();

  InputBorder _border() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: const BorderSide(color: Colors.black, width: 2),
  );

  TextStyle get _labelStyle => ThemeTextStyle.recipeNameTextFieldStyle;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final address = _addressController.text.trim();
      final phone = _phoneController.text.trim();

      try {
        await _controller.saveAdditionalUserInfo(context, widget.userId, address, phone);

        widget.onRegistered();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل حفظ البيانات، حاول مرة أخرى')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('العنوان (اختياري)', style: _labelStyle),
            const SizedBox(height: 8),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: 'أدخل عنوانك هنا',
                border: _border(),
                enabledBorder: _border(),
                focusedBorder: _border(),
              ),
            ),
            const SizedBox(height: 16),
            Text('رقم الهاتف (اختياري)', style: _labelStyle),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'أدخل رقم هاتفك',
                border: _border(),
                enabledBorder: _border(),
                focusedBorder: _border(),
              ),
            ),
            const SizedBox(height: 28),
            CustomSubmitButton(onPressed: _submit, label: 'حفظ ومتابعة'),
          ],
        ),
      ),
    );
  }
}
