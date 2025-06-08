class Constants {
  static const String defaultAvatarUrl =
      'https://img.freepik.com/premium-vector/avatar-profile-icon-flat-style-female-user-profile-vector-illustration-isolated-background-women-profile-sign-business-concept_157943-38866.jpg?semt=ais_hybrid&w=740';

  static const String cloudinaryUploadUrl =
      'https://api.cloudinary.com/v1_1/dflfjyux4/image/upload';

  static const String cloudinaryUploadPreset = 'flutter_unsigned';

  static const String errorInvalidEmail = 'يرجى إدخال بريد إلكتروني صحيح';
  static const String errorEmptyUsername = 'يرجى إدخال اسم المستخدم';
  static const String errorProfileNotLoaded = 'حدث خطأ، لم يتم تحميل البيانات.';
  static const String errorImageUpload = 'فشل في رفع الصورة';
  static const String errorNoChanges = 'لا يوجد أي تعديل جديد';
  static const String successProfileSaved = 'تم حفظ البيانات بنجاح';

  static const String successEmailVerificationSent =
      'تم إرسال رابط التحقق إلى بريدك الجديد، يرجى تسجيل الخروج والدخول مجددا بعد التحقق من البريد الالكتروني.';
  static const String errorEmailSame = 'البريد الالكتروني مطابق للقديم, يرجى تغييره';
  static const String errorNotLoggedIn = 'المستخدم غير مسجل الدخول';

  static const String successLogout = 'تم تسجيل الخروج بنجاح';
  static const String errorLogout = 'فشل في تسجيل الخروج: ';
  static const String errorEmailChange = 'حدث خطأ أثناء محاولة تغيير البريد الإلكتروني: ';

  static const String errorOldPasswordIncorrect = 'كلمة السر القديمة غير صحيحة';
  static const String errorInvalidCredential =
      'بيانات التحقق غير صحيحة. تأكد من كلمة المرور القديمة.';
  static const String errorUnexpected = 'حدث خطأ غير متوقع';
  static const String errorSamePassword = 'كلمة المرور الجديدة يجب أن تختلف عن القديمة';
  static const String errorUserNotLoggedIn = 'لم يتم تسجيل الدخول';
  static const String successPasswordChanged = 'تم تغيير كلمة المرور بنجاح';

  static const String errorOldPasswordRequired = 'يرجى إدخال كلمة المرور القديمة';
  static const String errorNewPasswordRequired = 'يرجى إدخال كلمة المرور الجديدة';
  static const String errorNewPasswordTooShort = 'يجب أن تكون 8 أحرف على الأقل';
  static const String errorNewPasswordNoUpper = 'يجب أن تحتوي على حرف كبير';
  static const String errorNewPasswordNoSymbol = 'يجب أن تحتوي على رمز مثل @ أو #';
  static const String errorPasswordsDoNotMatch = 'كلمة المرور غير متطابقة';

}
