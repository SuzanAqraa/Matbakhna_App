class ProfileFieldValidators {
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال اسم المستخدم';
    }
    if (value.length < 3) {
      return 'يجب أن يكون الاسم على الأقل 3 أحرف';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'يرجى إدخال بريد إلكتروني صالح';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      final phoneRegex = RegExp(r'^[0-9]{9,15}$');
      if (!phoneRegex.hasMatch(value.trim())) {
        return 'يرجى إدخال رقم هاتف صحيح';
      }
    }
    return null;
  }

  static String? validateAddress(String? value) {
    return null;
  }
}
