import 'package:flutter/material.dart';

import '../../../core/utils/brand_colors.dart';
import '../../../core/utils/textfeild_styles.dart';

class SignUpAdditionalInfoForm extends StatefulWidget {
  final Function(String address, String phone) onSubmit;

  const SignUpAdditionalInfoForm({super.key, required this.onSubmit});

  @override
  State<SignUpAdditionalInfoForm> createState() =>
      _SignUpAdditionalInfoFormState();
}

class _SignUpAdditionalInfoFormState extends State<SignUpAdditionalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _addressError;
  String? _phoneError;

  InputBorder _border() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: const BorderSide(color: Colors.black, width: 2),
  );

  TextStyle get _labelStyle => ThemeTextStyle.recipeNameTextFieldStyle;

  void _submit() {
    setState(() {
      _addressError = null;
      _phoneError = null;
    });

    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _addressController.text.trim(),
        _phoneController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text('العنوان (اختياري)', style: _labelStyle),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              hintText: 'أدخل عنوانك هنا',
              border: _border(),
              enabledBorder: _border(),
              focusedBorder: _border(),
              errorText: _addressError,
            ),
          ),
          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerRight,
            child: Text('رقم الهاتف (اختياري)', style: _labelStyle),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'أدخل رقم هاتفك',
              border: _border(),
              enabledBorder: _border(),
              focusedBorder: _border(),
              errorText: _phoneError,
            ),
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: BrandColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'حفظ ومتابعة',
                style: ThemeTextStyle.ButtonTextFieldStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
