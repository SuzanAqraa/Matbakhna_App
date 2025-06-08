
class PasswordValidators {
  static String? validateOldPassword(String? value) {
    if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور القديمة';
    return null;
  }

  static String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور الجديدة';
    if (value.length < 8) return 'يجب أن تكون 8 أحرف على الأقل';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'يجب أن تحتوي على حرف كبير';
    if (!RegExp(r'[!@#\$&*~%^]').hasMatch(value)) return 'يجب أن تحتوي على رمز مثل @ أو #';
    return null;
  }

  static String? validateConfirmPassword(String? value, String newPassword) {
    if (value != newPassword) return 'كلمة المرور غير متطابقة';
    return null;
  }
}
