import 'package:firebase_auth/firebase_auth.dart';

String handleError(FirebaseAuthException errorCode) {
  switch (errorCode.code) {
    case 'app-deleted':
      return 'التطبيق محذوف';
    case 'expired-action-code':
      return 'الشفرة اخذت وقت طويل من زمن الارسال';
    case 'invalid-action-code':
      return 'الشفرة غير صحيحة';
    case 'user-disabled':
      return 'هذا المستخدم غير مفعل حاليا';
    case 'user-not-found':
      return 'هذا المستخدم غير موجود';
    case 'weak-password':
      return 'كلمة السر ضعيفة جدا, جرب كلمة سر أخرى';
    case 'email-already-in-use':
      return 'عنوان البريد الالكتروني مستخدم بالفعل, جرب تسجيل الدخول بنفس العنوان';
    case 'invalid-email':
      return 'عنوان البريد الاكتروني هذا غير صحيح';
    case 'operation-not-allowed':
      return 'صلاحيات غير متوفرة';
    case 'account-exists-with-different-credential':
      return 'الحساب موجود بطريقة تسجيل دخول اخرى';
    case 'auth-domain-config-required':
      return 'اعدادات مطلوبة';
    case 'credential-already-in-use':
      return 'معرف الاعتماد مستخدم بالفعل';
    case 'operation-not-supported-in-this-environment':
      return 'العملية غير مدعومة في هذا التطبيق';
    case 'timeout':
      return 'مشكلة في الشبكة';
    case 'missing-android-pkg-name':
      return 'مشكلة في التطبيق';
    case 'missing-continue-uri':
      return 'عنوان الخدمة غير متوفر';
    case 'missing-ios-bundle-id':
      return 'اسم تطبيق الاي او اس غير متوفر';
    case 'invalid-continue-uri':
      return 'عنوان الخدمة غير صحيح';
    case 'unauthorized-continue-uri':
      return 'اذونات عنوان الخدمة بلا ترخيص';
    case 'invalid-dynamic-link-domain':
      return 'خطأ في رابط الحزمة';
    case 'argument-error':
      return 'خطأ في المدخلات';
    case 'invalid-persistence-type':
      return ' طريقة تثبيت البيانات غير صحيحة';
    case 'unsupported-persistence-type':
      return 'خطأ اثناء تثبيت البيانات';
    case 'invalid-credential':
      return 'خطأ في تسجيل الدخول';
    case 'wrong-password':
      return 'كلمة السر غير صحيحة';
    case 'invalid-verification-code':
      return 'الشفرة غير صحيحة';
    case 'invalid-verification-id':
      return 'المعرف غير صحيح';
    case 'custom-token-mismatch':
      return 'التوكن غير متطابق';
    case 'invalid-custom-token':
      return 'التوكن غير صحيح';
    case 'captcha-check-failed':
      return 'الكابشا فشلت';
    case 'invalid-phone-number':
      return 'رقم الهاتف غير صحيح';
    case 'missing-phone-number':
      return 'رقم الهاتف غير موجود';
    case 'quota-exceeded':
      return 'تخطيت حدك من الرسائل, الرجاء المحاولة لاحقا';
    case 'cancelled-popup-request':
      return 'تم الغاء المحاولة';
    case 'popup-blocked':
      return 'تم حظر المحاولة';
    case 'popup-closed-by-user':
      return 'تم الغاء المحاولة من قبل المستخدم';
    case 'unauthorized-domain':
      return 'اذونات غير متوفرة';
    case 'invalid-user-token':
      return 'توكن المستخدم غير صحيح';
    case 'user-token-expired':
      return 'التوكن منتهي الصلاحية';
    case 'null-user':
      return 'لم يتم تسجيل الدخول في التطبيق بعد, الرجاء تسجيل الدخول';
    case 'app-not-authorized':
      return 'التطبيق لا يمتلك صلاحيات كافية';
    case 'invalid-api-key':
      return 'شفرة الأيه بي آي غير صحيحة';
    case 'network-request-failed':
      return 'فشل في الشبكة';
    case 'requires-recent-login':
      return 'هذا الاجراء حساس ويتطلب تسجيل الدخول من فترة قصيرة';
    case 'too-many-requests':
      return 'محاولات كثيرة, الرجاء المحاولة لاحقا';
    case 'web-storage-unsupported':
      return 'التخزين في المتصفح غير مدعوم';
    case 'invalid-claims':
      return 'المطالبات غير مشروعة';
    case 'claims-too-large':
      return 'المطالبات كبيرة في الحجم';
    case 'id-token-expired':
      return 'توكن المعرف منتهي الصلاحية';
    case 'id-token-revoked':
      return 'معرف التوكن تم رفضه';
    case 'invalid-argument':
      return 'مدخلات غير صحيحة';
    case 'invalid-creation-time':
      return 'وقت انشاْ الحساب غير صحيح';
    case 'invalid-disabled-field':
      return 'حقل ملغي';
    case 'invalid-display-name':
      return 'هذا الاسم لا يمكن استخدامه في التطبيق';
    case 'invalid-email-verified':
      return 'عنوان البريد الالكتروني غير صحيح';
    case 'invalid-hash-algorithm':
      return 'خطأ في الخوارزمية';
    case 'invalid-hash-block-size':
      return 'خطأ في الخوارزمية';
    case 'invalid-hash-derived-key-length':
      return 'خطأ في الخوارزمية';
    case 'invalid-hash-key':
      return 'خطأ في الخوارزمية';
    case 'invalid-hash-memory-cost':
      return 'خطأ في الخوارزمية';
    case 'invalid-hash-parallelization':
      return 'خطأ في الخوارزمية';
    case 'invalid-hash-rounds':
      return 'خطأ في الخوارزمية';
    case 'invalid-hash-salt-separator':
      return 'خطأ في الخوارزمية';
    case 'invalid-id-token':
      return 'توكن المعرف غير صحيح';
    case 'invalid-last-sign-in-time':
      return 'خطأ في وقت آخر تسجيل دخول';
    case 'invalid-page-token':
      return 'خطأ في توكن الصفحة';
    case 'invalid-password':
      return 'كلمة السر غير ممكنة';
    case 'invalid-password-hash':
      return 'خطأ في الخوارزمية';
    case 'invalid-password-salt':
      return 'خطأ في الخوارزمية';
    case 'invalid-photo-url':
      return 'هذا الرابط لا يحتوي على صورة';
    case 'invalid-provider-id':
      return 'مزو الخدمة غير صحيح';
    case 'invalid-session-cookie-duration':
      return 'الكوكيز منتهية الصلاحية';
    case 'invalid-uid':
      return 'رمز المستخدم غير صحيح';
    case 'invalid-user-import':
      return 'استيرادات المستخدم غير صحيحة';
    case 'invalid-provider-data':
      return 'بيانات مزود الخدمة غير صحيحة';
    case 'maximum-user-count-exceeded':
      return 'عدد المستخدمين وصل الحد الاقصى';
    case 'missing-hash-algorithm':
      return 'خطأ في الخوارزمية';
    case 'missing-uid':
      return 'هذا المستخدم ليس لديه شفرة';
    case 'reserved-claims':
      return 'مطالبات محفوظة';
    case 'session-cookie-revoked':
      return 'الكوكي مرفوضة';
    case 'uid-alread-exists':
      return 'رمز المستخدم موجود بالفعل';
    case 'email-already-exists':
      return 'يوجد حساب بالفعل يستخدم نفس عنوان البريد الالكترونيو الرجاء تسجيل الدخول به';
    case 'phone-number-already-exists':
      return 'يوجد حساب بالفعل يستخدم نفس رقم الهاتف';
    case 'project-not-found':
      return 'المشروع غير موجود';
    case 'insufficient-permission':
      return 'صلاحيات غير كافية';
    case 'internal-error':
      return 'خطأ داخلي';
    case 'channel-error':
      return "بعض الحقول فارغة";
    default:
      return "خطأ غير معرف";
  }
}
