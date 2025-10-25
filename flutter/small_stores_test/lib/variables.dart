import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// المتحول الأساسي للغة
String language_app = "ar";

// دالة لحفظ اللغة
Future<void> saveLanguage(String lang) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('app_language', lang);
}

// دالة لتحميل اللغة
Future<void> loadLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  language_app = prefs.getString('app_language') ?? 'ar';
  _updateTexts(); // تحديث النصوص بعد تحميل اللغة
}

// دالة لتحديث كل النصوص بناءً على اللغة
void _updateTexts() {
  if (language_app == "ar") {
    // عربي
    a_store_name_s = 'اسم المتجر';
    a_store_plane_s = 'مكان المتجر';
    a_store_note_s = 'لمحة عن المتجر';
    a_store_phone_s = 'جوال المتجر';
    a_store_class_s = 'فئة المتجر';

    a_product_name_s = 'اسم المنتج';
    a_product_note_s = 'لمحة عن المنتج';
    a_product_type_s = 'نوع المنتج';
    a_product_monye_s = 'سعر المنتج بالدولار';
    a_product_stati_s = 'حالة المنتج: متوفر';

    a_login_b = 'تسجيل الدخول';
    a_createuser_b = 'إنشاء حساب جديد';
    a_createuser_q_s = 'هل لديك حساب؟';
    a_reset_password_b = 'اضغط للمصادقة بالبصمة';
    a_reset_password_l = 'هل نسيت كلمة السر؟';
    a_email_m = 'يرجى إدخال البريد الإلكتروني';
    a_password_m = 'يرجى إدخال كلمة السر';
    a_email_l = 'البريد الإلكتروني';
    a_password_l = 'كلمة السر';

    a_createuser_s = 'إنشاء حساب';
    a_last_name_m = 'يرجى إدخال اسمك الأخير';
    a_first_name_m = 'يرجى إدخال اسمك الأول';
    a_plan_m = 'يرجى إدخال مكان الإقامة';
    a_phone_m = 'يرجى إدخال رقم الجوال';
    a_plan_l = 'مكان الإقامة';
    a_phone_l = 'رقم الجوال';
    a_first_name_l = 'الاسم الأول';
    a_last_name_l = 'الاسم الأخير';

    a_user_name_s = 'الاسم';
    a_user_phone_s = 'رقم الجوال';
    a_user_email_s = 'البريد الإلكتروني';
    a_user_plan_s = 'مكان الإقامة';
    language_l = 'لغة التطبيق';
    language_a = 'عربي';
    language_e = 'انكليزي';
    type_user = 'نوع الحساب';
    color_app = 'لون التطبيق';

    a_add_store_s = 'إضافة متجر';
    a_class_store_s = 'فئة متجر';
    a_plan_store_m = 'يرجى إدخال مكان متجر';
    a_store_name_m = 'يرجى إدخال اسم متجر';
    a_store_class_m = 'يرجى إدخال فئة متجر';

    a_edit_store_s = 'تعديل متجر';
    a_store_logo_s = 'شعار متجر';
    a_store_logo_m = 'يرجى إدخال شعار متجر';

    a_add_product_s = 'إضافة منتج';
    a_class_product_s = 'إضافة المنتج';
    a_plan_product_m = 'يرجى إدخال مكان المنتج';
    a_product_name_m = 'يرجى إدخال اسم المنتج';
    a_product_class_m = 'يرجى إدخال فئة المنتج';

    a_edit_product_s = 'تعديل المنتج';
    a_product_logo_s = 'صورة المنتج';
    a_product_logo_m = 'يرجى إدخال صورة المنتج';

    a_app_note_s = 'لمحة عن التطبيق';
    a_user_data_t = 'معلومات الشخصية';
    a_user_store_t = 'متاجر المستخدم';

    a_main_page_d = 'الصفحة الرئيسية';
    a_about_app_d = 'حول التطبيق';
    a_favort_d = 'المفضلة';
    a_ann_d = 'الإعلانات';
    a_advice_d = 'نصيحة';
    a_logout_d = 'تسجيل الخروج';
    a_profile_d = 'ملف الشخصي';
    a_app_out_d = 'خروج من التطبيق';

    a_edit_profile_s = 'تعديل الملف الشخصي';
    a_edit_profile_photo_s = 'صورة الملف الشخصي';
    a_edit_profile_photo_m = 'يرجى إدخال صورة الملف الشخصي';

    a_AddAnnouncement_s = 'إضافة إعلان';
    a_text_Announcement_l = 'نص الإعلان';
    a_photo_Announcement_l = 'صورة إعلان';

    a_show_store_t = 'المتجر';
    a_show_product_t = 'المنتجات';

    a_FirstLaunch_s = '''مرحبًا بك في تطبيق Dukkani! 
منصتك المثالية للإعلان عن مشروعك 
نوفر لك أدوات ونصائح تسويقية لتعزيز مشروعك بكل سهولة مع واجهة بسيطة وتقنيات حديثة. 
 انطلق في رحلتك مميزة...''';
    a_start_b = 'إبدأ';

    a_not_s = 'تطبيقنا هو الأول في مجاله، مُتخصص بالإعلان عن المشاريع الصغيرة،\n حيث يوفر منصة مبتكرة تسهل عرض المنتجات والخدمات بطريقة بسيطة وسلسة.\n يمنح التطبيق أصحاب المشاريع الصغيرة الفرصة للتعريف بمشروعاتهم والتواصل مع العملاء المحتملين، \nمما يُعزز ظهورهم في السوق.\n هدفنا هو دعم رواد الأعمال ودفع عجلة الابتكار والنمو لدى المشاريع الصغيرة، \n من خلال توفير واجهة مستخدم سهلة الاستخدام وأدوات فعالة للترويج. \n مما يسمح لباقي المستخدمين التعرف على مشروعه';

    a_favort_s = 'المفضلة';
    a_add_b = 'إضافة';
    a_edit_b = 'تعديل';

    a_logout_confirm_title = 'تسجيل الخروج';
    a_logout_confirm_message = 'هل تريد تسجيل الخروج؟';
    a_final_confirm_title = 'تأكيد نهائي';
    a_logout_final_message = 'هل أنت متأكد من أنك تريد تسجيل الخروج؟';
    a_exit_app_title = 'خروج من التطبيق';
    a_exit_app_message = 'هل تريد الخروج من التطبيق؟';
    a_exit_app_final_message = 'هل أنت متأكد من أنك تريد الخروج من التطبيق؟';
    a_cancel = 'إلغاء';
    a_yes = 'نعم';
    a_confirm = 'تأكيد';
    a_exit = 'خروج';

    // ShowProduct نصوص
    a_add_to_favorite = 'إضافة إلى المفضلة';
    a_remove_from_favorite = 'حذف من المفضلة';
    a_readd_to_favorite = 'إعادة الإضافة';
    a_likes_count = 'عدد المعجبين';
    a_product_details = 'تفاصيل المنتج';
    a_product_price = 'سعر المنتج';
    a_product_status = 'حالة المنتج';
    a_available = 'متوفر';
    a_not_available = 'غير متوفر';

// ShowProduct رسائل
    a_product_added_already = 'المنتج مضاف مسبقاً';
    a_error_occurred = 'حدث خطأ';
    a_loading_data = 'جاري تحميل البيانات...';
    a_product_loaded = 'تم تحميل المنتج';
    a_favorites_loaded = 'تم تحميل المفضلات';
    a_favorite_state = 'حالة المفضلة';
    a_updating_favorite = 'جاري تحديث المفضلة';
    a_adding_new_favorite = 'جاري إضافة مفضلة جديدة';
    a_product_exists_reloading = 'المنتج موجود مسبقاً، جاري إعادة التحميل...';
    a_error_loading_data = 'خطأ في تحميل البيانات';
    a_error_loading_favorites = 'تحذير: تعذر تحميل المفضلات';
    a_error_updating_likes = 'خطأ في تحديث عدد الإعجابات';
    a_error_in_favorite_action = 'خطأ في إجراء المفضلة';

    my_store_l='متاجري';
    my_announce_l='إعلاناتي';

    availability_status ='حالة التوفر';
    error_store_loading_data_m='فشل تحميل بيانات المتجر';
    error_update_data_m='حدث خطأ أثناء التحديث';
    product_activated_m='تم تفعيل توفر المنتج';
    product_activated_no_m='تم إلغاء توفر المنتج';
    delete_product_m='تم حذف المنتج بنجاح';
    error_delete_product_m='فشل حذف المنتج';
    a_confirm_end_l='تأكيد نهائي';
    delete_product_end_l='هل أنت متأكد من أنك تريد حذف هذا المنتج؟ لا يمكن التراجع عن هذه العملية.';
    a_confirm_delete_l='تأكيد الحذف';
    delete_product_q_l='هل تريد حذف هذا المنتج؟';

    // AddAnnouncement نصوص
    a_announcement_note_label = 'نص الإعلان';
    a_announcement_image_label = 'صورة الإعلان';
    a_please_enter_announcement_text = 'رجاء ادخال نص الإعلان';
    a_announcement_max_length_error = 'لا يجوز أن يكون الإعلان أكثر من 60 محرف';
    a_please_enter_announcement_image = 'رجاء ادخال صورة الإعلان';
    a_pick_image_button = 'اختيار صورة';
    a_adding_loading_text = 'جاري الإضافة...';
    a_announcement_added_success = 'تم إضافة الإعلان بنجاح!';
    a_announcement_add_failed = 'فشل في إضافة الإعلان';
    a_image_pick_failed = 'فشل في اختيار الصورة';
    a_image_required = 'يجب اختيار صورة للإعلان';

    // Login نصوص
    a_invalid_email_error = 'البريد الإلكتروني غير صالح';
    a_reset_password_via_email = 'نغير كلمة المرور باستخدام البريد الإلكتروني';
    a_login_failed = 'فشل تسجيل الدخول';
    a_email_not_registered = 'البريد الإلكتروني غير مسجل في النظام';
    a_account_banned = 'الحساب محظور. يرجى التواصل مع الدعم';
    a_invalid_credentials = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
    a_unexpected_error = 'حدث خطأ غير متوقع';
    a_user_data_failed = 'فشل في تكوين بيانات المستخدم';
    a_login_success = 'تم تسجيل الدخول بنجاح';
    a_biometric_auth = 'المصادقة البيومترية';
    a_biometric_not_available = 'المصادقة البيومترية غير متاحة';
    a_try_again = 'حاول مرة أخرى';

    image_selected_ann ='يجب اختيار صورة للإعلان';

    // AddProduct نصوص
    a_product_type_label = 'نوع المنتج';
    a_please_enter_product_name = 'يرجى ادخال اسم المنتج';
    a_please_select_product_type = 'يرجى اختيار نوع المنتج';
    a_please_enter_product_overview = 'يرجى ادخال لمحة عن المنتج';
    a_please_enter_product_price = 'يرجى ادخال سعر المنتج';
    a_please_enter_product_image = 'يرجى ادخال صورة المنتج';
    a_select_image_button = 'اختيار صورة';
    a_no_image_selected = 'لم يتم اختيار صورة';
    a_image_too_large = 'حجم الصورة كبير جداً';
    a_please_select_product_image = 'يرجى اختيار صورة للمنتج';
    a_product_added_success = 'تم إضافة المنتج بنجاح';
    a_product_add_failed = 'فشل في إضافة المنتج';

    // AddStore نصوص
    a_store_type_label = 'نوع المتجر';
    a_please_enter_store_name = 'يرجى ادخال اسم المتجر';
    a_please_select_store_type = 'يرجى اختيار نوع المتجر';
    a_please_enter_store_overview = 'يرجى ادخال لمحة عن المتجر';
    a_please_enter_store_phone = 'يرجى ادخال رقم الهاتف';
    a_please_enter_store_location = 'يرجى ادخال موقع المتجر';
    a_please_enter_store_image = 'يرجى ادخال صورة المتجر';
    a_store_added_success = 'تم إضافة المتجر بنجاح ';
    a_store_add_failed = 'فشل في إضافة المتجر';
    a_failed_to_load_categories = 'فشل في تحميل الفئات';
    a_operation_failed = 'فشل العملية';
    a_loading_categories_failed = 'فشل في تحميل الفئات';

    // AnnouncementScreen نصوص
    a_search_announcement_hint = 'بحث عن إعلان أو متجر';
    a_choose_date_range = 'اختر نطاق زمني';
    a_clear_filter = 'مسح الفلترة';
    a_selected_date_range = 'النطاق الزمني المحدد:';
    a_start_date = 'تاريخ البداية';
    a_end_date = 'تاريخ النهاية';
    a_date_range_selected = 'تم تحديد النطاق الزمني بنجاح!';
    a_no_announcements = 'لا توجد إعلانات حالياً';
    a_announcements_loading_error = 'خطأ في جلب الإعلانات';
    a_date_conversion_error = 'خطأ في تحويل التاريخ';
    a_store_not_found = 'متجر غير معروف';
    a_date_range_confirmation = 'تم تحديد النطاق الزمني بنجاح!';
    a_start_date_selected = 'تم تحديد تاريخ البداية';
    a_end_date_selected = 'تم تحديد تاريخ النهاية';

// MyAnnouncement نصوص
    a_my_announcements_title = 'إعلاناتي';
    a_delete_announcement_confirm = 'تأكيد الحذف';
    a_delete_announcement_question = 'هل تريد حذف هذا الإعلان؟';
    a_announcement_deleted_success = 'تم حذف الإعلان بنجاح';
    a_announcement_delete_failed = 'فشل حذف الإعلان';
    a_edit_option = 'تعديل';
    a_delete_option = 'حذف';
    a_view_store_tooltip = 'عرض المتجر';

    // ChekPasswordCode نصوص
    a_enter_code_sent_to = 'ادخل الكود المرسل إلى';
    a_check_your_email = 'تحقق من بريدك الإلكتروني للحصول على كود التحقق';
    a_verification_code = 'كود التحقق';
    a_enter_verification_code = 'ادخل كود التحقق';
    a_confirm_code = 'تأكيد الكود';
    a_verifying = 'جاري التحقق...';
    a_code_verified_success = 'تم التحقق بنجاح';
    a_invalid_code = 'كود التحقق غير صحيح';
    a_incorrect_data = 'بيانات غير صحيحة';
    a_server_error = 'حدث خطأ في الخادم';
    a_connection_error = 'خطأ في الاتصال';
    a_server_returns_invalid_data = 'الخادم يعيد بيانات غير صحيحة';
    a_please_enter_verification_code = 'يرجى إدخال كود التحقق';

    // CreateUser نصوص
    a_store_owner_label = 'صاحب مشروع';
    a_password_too_short = 'يجب ان تكون كلمة المرور اطول من 8 محارف';
    a_account_created_success = 'تم إنشاء الحساب بنجاح';
    a_fingerprint_not_supported = 'جهازك لا يدعم المصادقة بالبصمة';
    a_touch_sensor_to_register = 'المس مستشعر البصمة للتسجيل';
    a_fingerprint_registered_success = 'تم تسجيل البصمة بنجاح';
    a_fingerprint_error = 'حدث خطأ في البصمة';
    a_user_data_save_failed = 'فشل في حفظ بيانات المستخدم محلياً';
    a_user_data_saved = 'تم حفظ بيانات المستخدم في الذاكرة المحلية';
    a_invalid_email_format = 'البريد الإلكتروني غير صالح';

// EditAnnouncement نصوص
    a_edit_announcement_title = 'تعديل إعلان';
    a_announcement_updated_success = 'تم تعديل الإعلان بنجاح!';
    a_announcement_update_failed = 'فشل في تعديل الإعلان';

    // EditProduct نصوص
    a_product_updated_success = 'تم تحديث المنتج بنجاح';
    a_product_update_failed = 'فشل في تحديث المنتج';

// EditProfile نصوص
    a_please_enter_full_name = 'يرجى ادخال اسمك الكامل';
    a_profile_updated_success = 'تم تعديل الحساب بنجاح';
    a_profile_update_failed = 'فشل التعديل';
    a_profile_update_error = 'خطأ أثناء تعديل المستخدم';

// EditStore نصوص
    a_loading_classes = 'جاري التحميل...';
    a_store_updated_success = 'تم تعديل المتجر بنجاح ';
    a_store_update_failed = 'حدث خطأ أثناء التعديل ';
    a_server_response_error = 'خطأ في معالجة الاستجابة من الخادم';
    a_error_fetching_categories = 'خطأ أثناء جلب الأصناف';

    a_no_favorites_message = 'لا توجد منتجات في المفضلة';

// إضافة هذه المتغيرات
    a_send_code = 'إرسال الكود';
    a_enter_email_for_code = 'ادخل بريدك الإلكتروني لإرسال كود التحقق';

    my_stores_not_found='لا توجد متاجر متاحة';

    product_search="بحث عن منتج";
    product_all='كل المنتجات';
    products_not_found='لا توجد منتجات';

    user_ann="إعلانات المستخدم";

    // إضافة هذه المتغيرات
    a_reset_password_title = 'تعيين كلمة المرور الجديدة';
    a_new_password = 'كلمة المرور الجديدة';
    a_confirm_password = 'تأكيد كلمة المرور';
    a_confirm_password_m = 'يرجى تأكيد كلمة المرور';
    a_passwords_not_match = 'كلمتا المرور غير متطابقتين';
    a_change_password = 'تغيير';
    a_password_reset_success = 'تم تغيير كلمة المرور بنجاح';
    a_password_reset_failed = 'فشل تغيير كلمة المرور';
    erorr_html="حدث خطأ في الخادم (صفحة HTML)";

// إضافة هذه المتغيرات
    a_delete_user = 'حذف المستخدم';
    a_delete_user_question = 'هل تريد حذف هذا المستخدم؟';
    a_delete_user_final_warning = 'هل أنت متأكد من أنك تريد حذف هذا المستخدم؟ لا يمكن التراجع عن هذه العملية.';
    a_user_deleted_success = 'تم حذف المستخدم بنجاح';
    a_user_delete_failed = 'فشل حذف المستخدم';

// إضافة هذه المتغيرات
    a_all_users = 'كل المستخدمين';
    a_search_users = 'بحث بالاسم أو الإيميل';
    a_no_users_found = 'لا يوجد مستخدمين';
    a_user_type_admin = 'مدير';
    a_user_type_store_owner = 'صاحب متجر';
    a_user_type_regular = 'زائر';
    a_user_type_default = 'مستخدم';

    a_data_loading_error = 'خطأ في جلب بيانات';

    // إضافة هذه المتغيرات
    a_delete_store = 'حذف المتجر';
    a_delete_store_question = 'هل تريد حذف هذا المتجر؟';
    a_delete_store_final_warning = 'هل أنت متأكد من أنك تريد حذف هذا المتجر؟ لا يمكن التراجع عن هذه العملية.';
    a_store_deleted_success = 'تم حذف المتجر بنجاح';
    a_store_delete_failed = 'فشل حذف المتجر';
    a_more_options = 'المزيد من الخيارات';
    a_unknown_category = 'غير معروف';

    a_no_stores_available = 'لا توجد متاجر حالياً';
    a_all_stores = 'كل المتاجر';

    a_loading_categories = 'جاري تحميل الفئات...';

    comment_t = "التعليقات";
    prodect_t =  "المنتج";
    comment_you = 'اكتب تعليقك...';
    comment_no = 'لا توجد تعليقات بعد';

  } else {
    // انجليزي
    a_store_name_s = 'Store Name';
    a_store_plane_s = 'Store Location';
    a_store_note_s = 'Store Overview';
    a_store_phone_s = 'Store Phone';
    a_store_class_s = 'Store Category';

    a_product_name_s = 'Product Name';
    a_product_note_s = 'Product Overview';
    a_product_type_s = 'Product Type';
    a_product_monye_s = 'Product Price in USD';
    a_product_stati_s = 'Product Status: Available';

    a_login_b = 'Login';
    a_createuser_b = 'Create New Account';
    a_createuser_q_s = 'Already have an account?';
    a_reset_password_b = 'Tap for Fingerprint Authentication';
    a_reset_password_l = 'Forgot Password?';
    a_email_m = 'Please enter email';
    a_password_m = 'Please enter password';
    a_email_l = 'Email';
    a_password_l = 'Password';

    a_createuser_s = 'Create Account';
    a_last_name_m = 'Please enter your last name';
    a_first_name_m = 'Please enter your first name';
    a_plan_m = 'Please enter your location';
    a_phone_m = 'Please enter your phone number';
    a_plan_l = 'Location';
    a_phone_l = 'Phone Number';
    a_first_name_l = 'First Name';
    a_last_name_l = 'Last Name';

    a_user_name_s = 'Name';
    a_user_phone_s = 'Phone Number';
    a_user_email_s = 'Email';
    a_user_plan_s = 'Location';
    language_l = 'App Language';
    language_a = 'Arabic';
    language_e = 'English';
    type_user = 'Account Type';
    color_app = 'App Color';

    a_add_store_s = 'Add Store';
    a_class_store_s = 'Store Category';
    a_plan_store_m = 'Please enter store location';
    a_store_name_m = 'Please enter store name';
    a_store_class_m = 'Please enter store category';

    a_edit_store_s = 'Edit Store';
    a_store_logo_s = 'Store Logo';
    a_store_logo_m = 'Please enter store logo';

    a_add_product_s = 'Add Product';
    a_class_product_s = 'Add Product';
    a_plan_product_m = 'Please enter product location';
    a_product_name_m = 'Please enter product name';
    a_product_class_m = 'Please enter product category';

    a_edit_product_s = 'Edit Product';
    a_product_logo_s = 'Product Image';
    a_product_logo_m = 'Please enter product image';

    a_app_note_s = 'About the App';
    a_user_data_t = 'Personal Information';
    a_user_store_t = 'User Stores';

    a_main_page_d = 'Main Page';
    a_about_app_d = 'About App';
    a_favort_d = 'Favorites';
    a_ann_d = 'Announcements';
    a_advice_d = 'advice';
    a_logout_d = 'Logout';
    a_profile_d = 'Profile';
    a_app_out_d = 'Exit App';

    a_edit_profile_s = 'Edit Profile';
    a_edit_profile_photo_s = 'Profile Photo';
    a_edit_profile_photo_m = 'Please enter profile photo';

    a_AddAnnouncement_s = 'Add Announcement';
    a_text_Announcement_l = 'Announcement Text';
    a_photo_Announcement_l = 'Announcement Image';

    a_show_store_t = 'Store';
    a_show_product_t = 'Products';

    a_FirstLaunch_s = '''Welcome to Dukkani App!
Your perfect platform for advertising your project
We provide you with tools and marketing tips to enhance your project easily with a simple interface and modern technologies.
Start your distinguished journey...''';
    a_start_b = 'Start';

    a_not_s = 'Our app is the first in its field, specialized in advertising small projects,\n providing an innovative platform that facilitates displaying products and services in a simple and smooth way.\n The app gives small project owners the opportunity to introduce their projects and communicate with potential customers,\n which enhances their market presence.\n Our goal is to support entrepreneurs and drive innovation and growth for small projects,\n by providing an easy-to-use user interface and effective promotion tools.\n allowing other users to learn about their project';

    a_favort_s = 'Favorites';
    a_add_b = 'Add';
    a_edit_b = 'Edit';

    a_logout_confirm_title = 'Logout';
    a_logout_confirm_message = 'Do you want to logout?';
    a_final_confirm_title = 'Final Confirmation';
    a_logout_final_message = 'Are you sure you want to logout?';
    a_exit_app_title = 'Exit App';
    a_exit_app_message = 'Do you want to exit the app?';
    a_exit_app_final_message = 'Are you sure you want to exit the app?';
    a_cancel = 'Cancel';
    a_yes = 'Yes';
    a_confirm = 'Confirm';
    a_exit = 'Exit';

    // ShowProduct texts
    a_add_to_favorite = 'Add to Favorite';
    a_remove_from_favorite = 'Remove from Favorite';
    a_readd_to_favorite = 'Re-add to Favorite';
    a_likes_count = 'Likes Count';
    a_product_details = 'Product Details';
    a_product_price = 'Product Price';
    a_product_status = 'Product Status';
    a_available = 'Available';
    a_not_available = 'Not Available';

// ShowProduct messages
    a_product_added_already = 'Product already added';
    a_error_occurred = 'An error occurred';
    a_loading_data = 'Loading data...';
    a_product_loaded = 'Product loaded';
    a_favorites_loaded = 'Favorites loaded';
    a_favorite_state = 'Favorite state';
    a_updating_favorite = 'Updating favorite';
    a_adding_new_favorite = 'Adding new favorite';
    a_product_exists_reloading = 'Product already exists, reloading...';
    a_error_loading_data = 'Error loading data';
    a_error_loading_favorites = 'Warning: Could not load favorites';
    a_error_updating_likes = 'Error updating likes count';
    a_error_in_favorite_action = 'Error in favorite action';

    my_store_l = 'My Stores';
    my_announce_l = 'My Announcements';

    availability_status = 'Availability Status';
    error_store_loading_data_m = 'Failed to load store data';
    error_update_data_m = 'An error occurred while updating';
    product_activated_m = 'Product availability activated';
    product_activated_no_m = 'Product availability canceled';
    delete_product_m = 'Product deleted successfully';
    error_delete_product_m = 'Failed to delete product';
    a_confirm_end_l = 'Final Confirmation';
    delete_product_end_l = 'Are you sure you want to delete this product? This action cannot be undone.';
    a_confirm_delete_l = 'Confirm Deletion';
    delete_product_q_l = 'Do you want to delete this product?';

    // AddAnnouncement texts
    a_announcement_note_label = 'Ad Text';
    a_announcement_image_label = 'Ad Image';
    a_please_enter_announcement_text = 'Please enter ad text';
    a_announcement_max_length_error = 'Ad text cannot exceed 60 characters';
    a_please_enter_announcement_image = 'Please select ad image';
    a_pick_image_button = 'Pick Image';
    a_adding_loading_text = 'Adding...';
    a_announcement_added_success = 'Ad added successfully!';
    a_announcement_add_failed = 'Failed to add ad';
    a_image_pick_failed = 'Failed to pick image';
    a_image_required = 'Please select an image for the ad';

    // Login texts
    a_invalid_email_error = 'Invalid email address';
    a_reset_password_via_email = 'Reset password via email';
    a_login_failed = 'Login failed';
    a_email_not_registered = 'Email not registered in the system';
    a_account_banned = 'Account banned. Please contact support';
    a_invalid_credentials = 'Email or password is incorrect';
    a_unexpected_error = 'An unexpected error occurred';
    a_user_data_failed = 'Failed to configure user data';
    a_login_success = 'Login successful';
    a_biometric_auth = 'Biometric Authentication';
    a_biometric_not_available = 'Biometric authentication not available';
    a_try_again = 'Try again';

    image_selected_ann ='An image must be selected for the advertisement';

    // AddProduct texts
    a_product_type_label = 'Product Type';
    a_please_enter_product_name = 'Please enter product name';
    a_please_select_product_type = 'Please select product type';
    a_please_enter_product_overview = 'Please enter product overview';
    a_please_enter_product_price = 'Please enter product price';
    a_please_enter_product_image = 'Please enter product image';
    a_select_image_button = 'Select Image';
    a_no_image_selected = 'No image selected';
    a_image_too_large = 'Image size is too large';
    a_please_select_product_image = 'Please select product image';
    a_product_added_success = 'Product added successfully';
    a_product_add_failed = 'Failed to add product';

    // AddStore texts
    a_store_type_label = 'Store Type';
    a_please_enter_store_name = 'Please enter store name';
    a_please_select_store_type = 'Please select store type';
    a_please_enter_store_overview = 'Please enter store overview';
    a_please_enter_store_phone = 'Please enter phone number';
    a_please_enter_store_location = 'Please enter store location';
    a_please_enter_store_image = 'Please enter store image';
    a_no_image_selected = 'No image selected';
    a_store_added_success = 'Store added successfully ';
    a_store_add_failed = 'Failed to add store';
    a_failed_to_load_categories = 'Failed to load categories';
    a_unexpected_error = 'An unexpected error occurred ';
    a_operation_failed = 'Operation failed';
    a_loading_categories_failed = 'Failed to load categories';

    // AnnouncementScreen texts
    a_search_announcement_hint = 'Search for an ad or store';
    a_choose_date_range = 'Choose date range';
    a_clear_filter = 'Clear filter';
    a_selected_date_range = 'Selected date range:';
    a_start_date = 'Start date';
    a_end_date = 'End date';
    a_date_range_selected = 'Date range selected successfully!';
    a_no_announcements = 'No announcements available';
    a_announcements_loading_error = 'Error loading announcements';
    a_date_conversion_error = 'Error converting date';
    a_store_not_found = 'Unknown store';
    a_date_range_confirmation = 'Date range selected successfully!';
    a_start_date_selected = 'Start date selected';
    a_end_date_selected = 'End date selected';

// MyAnnouncement texts
    a_my_announcements_title = 'My Announcements';
    a_delete_announcement_confirm = 'Confirm Deletion';
    a_delete_announcement_question = 'Do you want to delete this announcement?';
    a_announcement_deleted_success = 'Announcement deleted successfully';
    a_announcement_delete_failed = 'Failed to delete announcement';
    a_edit_option = 'Edit';
    a_delete_option = 'Delete';
    a_view_store_tooltip = 'View Store';

    // ChekPasswordCode texts
    a_enter_code_sent_to = 'Enter the code sent to';
    a_check_your_email = 'Check your email for the verification code';
    a_verification_code = 'Verification Code';
    a_enter_verification_code = 'Enter verification code';
    a_confirm_code = 'Confirm Code';
    a_verifying = 'Verifying...';
    a_code_verified_success = 'Verification successful';
    a_invalid_code = 'Invalid verification code';
    a_incorrect_data = 'Incorrect data';
    a_server_error = 'Server error occurred';
    a_connection_error = 'Connection error';
    a_server_returns_invalid_data = 'Server returns invalid data';
    a_please_enter_verification_code = 'Please enter verification code';

    // CreateUser texts
    a_store_owner_label = 'Project Owner';
    a_password_too_short = 'Password must be longer than 8 characters';
    a_account_created_success = 'Account created successfully';
    a_fingerprint_not_supported = 'Your device does not support fingerprint authentication';
    a_touch_sensor_to_register = 'Touch the fingerprint sensor to register';
    a_fingerprint_registered_success = 'Fingerprint registered successfully';
    a_fingerprint_error = 'Fingerprint error occurred';
    a_user_data_save_failed = 'Failed to save user data locally';
    a_user_data_saved = 'User data saved to local storage';
    a_invalid_email_format = 'Invalid email format';

// EditAnnouncement texts
    a_edit_announcement_title = 'Edit Announcement';
    a_announcement_updated_success = 'Announcement updated successfully!';
    a_announcement_update_failed = 'Failed to update announcement';

// EditProduct texts
    a_product_updated_success = 'Product updated successfully';
    a_product_update_failed = 'Failed to update product';

// EditProfile texts
    a_please_enter_full_name = 'Please enter your full name';
    a_profile_updated_success = 'Profile updated successfully';
    a_profile_update_failed = 'Update failed';
    a_profile_update_error = 'Error while updating user';

// EditStore texts
    a_loading_classes = 'Loading...';
    a_store_updated_success = 'Store updated successfully ';
    a_store_update_failed = 'An error occurred while updating ';
    a_server_response_error = 'Error processing server response';
    a_error_fetching_categories = 'Error fetching categories';

    a_no_favorites_message = 'No favorite products';

// إضافة هذه المتغيرات
    a_send_code = 'Send Code';
    a_enter_email_for_code = 'Enter your email to send verification code';

    my_stores_not_found='No stores available';

    product_search="Search for a product";
    product_all='All products';
    products_not_found='No products available';

    user_ann="User Announcements";

    // إضافة هذه المتغيرات
    a_reset_password_title = 'Set New Password';
    a_new_password = 'New Password';
    a_confirm_password = 'Confirm Password';
    a_confirm_password_m = 'Please confirm password';
    a_passwords_not_match = 'Passwords do not match';
    a_change_password = 'Change';
    a_password_reset_success = 'Password changed successfully';
    a_password_reset_failed = 'Failed to change password';
    erorr_html="An error occurred on the server (HTML page)";

// إضافة هذه المتغيرات
    a_delete_user = 'Delete User';
    a_delete_user_question = 'Do you want to delete this user?';
    a_delete_user_final_warning = 'Are you sure you want to delete this user? This action cannot be undone.';
    a_user_deleted_success = 'User deleted successfully';
    a_user_delete_failed = 'Failed to delete user';

// إضافة هذه المتغيرات
    a_all_users = 'All Users';
    a_search_users = 'Search by name or email';
    a_no_users_found = 'No users found';
    a_user_type_admin = 'Admin';
    a_user_type_store_owner = 'Store Owner';
    a_user_type_regular = 'Regular User';
    a_user_type_default = 'User';

    a_data_loading_error = "Error fetching data";

    // إضافة هذه المتغيرات
    a_delete_store = 'Delete Store';
    a_delete_store_question = 'Do you want to delete this store?';
    a_delete_store_final_warning = 'Are you sure you want to delete this store? This action cannot be undone.';
    a_store_deleted_success = 'Store deleted successfully';
    a_store_delete_failed = 'Failed to delete store';
    a_more_options = 'More Options';
    a_unknown_category = 'Unknown';

    a_no_stores_available = 'No stores available';
    a_all_stores = 'All Stores';

    a_loading_categories = 'Loading categories...';

    comment_t = "Comments";
    prodect_t =  "product";
    comment_you = 'Write your comment...';
    comment_no = 'No comments yet';

  }
}

// تعريف كل المتحولات
String a_store_name_s = 'اسم المتجر';
String a_store_plane_s = 'مكان المتجر';
String a_store_note_s = 'لمحة عن المتجر';
String a_store_phone_s = 'جوال المتجر';
String a_store_class_s = 'فئة المتجر';

String a_product_name_s = 'اسم المنتج';
String a_product_note_s = 'لمحة عن المنتج';
String a_product_type_s = 'نوع المنتج';
String a_product_monye_s = 'سعر المنتج بالدولار';
String a_product_stati_s = 'حالة المنتج: متوفر';

String a_login_b = 'تسجيل الدخول';
String a_createuser_b = 'إنشاء حساب جديد';
String a_createuser_q_s = 'هل لديك حساب؟';
String a_reset_password_b = 'اضغط للمصادقة بالبصمة';
String a_reset_password_l = 'هل نسيت كلمة السر؟';
String a_email_m = 'يرجى إدخال البريد الإلكتروني';
String a_password_m = 'يرجى إدخال كلمة السر';
String a_email_l = 'البريد الإلكتروني';
String a_password_l = 'كلمة السر';

String a_createuser_s = 'إنشاء حساب';
String a_last_name_m = 'يرجى إدخال اسمك الأخير';
String a_first_name_m = 'يرجى إدخال اسمك الأول';
String a_plan_m = 'يرجى إدخال مكان الإقامة';
String a_phone_m = 'يرجى إدخال رقم الجوال';
String a_plan_l = 'مكان الإقامة';
String a_phone_l = 'رقم الجوال';
String a_first_name_l = 'الاسم الأول';
String a_last_name_l = 'الاسم الأخير';

String a_user_name_s = 'الاسم';
String a_user_phone_s = 'رقم الجوال';
String a_user_email_s = 'البريد الإلكتروني';
String a_user_plan_s = 'مكان الإقامة';
String language_l = 'لغة التطبيق';
String language_a = 'عربي';
String language_e = 'انكليزي';
String type_user = 'نوع الحساب';
String color_app = 'لون التطبيق';

String a_add_store_s = 'إضافة متجر';
String a_class_store_s = 'فئة متجر';
String a_plan_store_m = 'يرجى إدخال مكان متجر';
String a_store_name_m = 'يرجى إدخال اسم متجر';
String a_store_class_m = 'يرجى إدخال فئة متجر';

String a_edit_store_s = 'تعديل متجر';
String a_store_logo_s = 'شعار متجر';
String a_store_logo_m = 'يرجى إدخال شعار متجر';

String a_add_product_s = 'إضافة منتج';
String a_class_product_s = 'إضافة المنتج';
String a_plan_product_m = 'يرجى إدخال مكان المنتج';
String a_product_name_m = 'يرجى إدخال اسم المنتج';
String a_product_class_m = 'يرجى إدخال فئة المنتج';

String a_edit_product_s = 'تعديل المنتج';
String a_product_logo_s = 'صورة المنتج';
String a_product_logo_m = 'يرجى إدخال صورة المنتج';

String a_app_note_s = 'لمحة عن التطبيق';
String a_user_data_t = 'معلومات الشخصية';
String a_user_store_t = 'متاجر المستخدم';

String a_main_page_d = 'الصفحة الرئيسية';
String a_about_app_d = 'حول التطبيق';
String a_favort_d = 'المفضلة';
String a_ann_d = 'الإعلانات';
String a_advice_d = 'نصيحة';
String a_logout_d = 'تسجيل الخروج';
String a_profile_d = 'ملف الشخصي';
String a_app_out_d = 'خروج من التطبيق';

String a_edit_profile_s = 'تعديل الملف الشخصي';
String a_edit_profile_photo_s = 'صورة الملف الشخصي';
String a_edit_profile_photo_m = 'يرجى إدخال صورة الملف الشخصي';

String a_AddAnnouncement_s = 'إضافة إعلان';
String a_text_Announcement_l = 'نص الإعلان';
String a_photo_Announcement_l = 'صورة إعلان';

String a_show_store_t = 'المتجر';
String a_show_product_t = 'المنتجات';

String a_FirstLaunch_s = '''مرحبًا بك في تطبيق Dukkani! 
منصتك المثالية للإعلان عن مشروعك 
نوفر لك أدوات ونصائح تسويقية لتعزيز مشروعك بكل سهولة مع واجهة بسيطة وتقنيات حديثة. 
 انطلق في رحلتك مميزة...''';
String a_start_b = 'إبدأ';

String a_not_s = 'تطبيقنا هو الأول في مجاله، مُتخصص بالإعلان عن المشاريع الصغيرة،\n حيث يوفر منصة مبتكرة تسهل عرض المنتجات والخدمات بطريقة بسيطة وسلسة.\n يمنح التطبيق أصحاب المشاريع الصغيرة الفرصة للتعريف بمشروعاتهم والتواصل مع العملاء المحتملين، \nمما يُعزز ظهورهم في السوق.\n هدفنا هو دعم رواد الأعمال ودفع عجلة الابتكار والنمو لدى المشاريع الصغيرة، \n من خلال توفير واجهة مستخدم سهلة الاستخدام وأدوات فعالة للترويج. \n مما يسمح لباقي المستخدمين التعرف على مشروعه';

String a_favort_s = 'المفضلة';
String a_add_b = 'إضافة';
String a_edit_b = 'تعديل';

String a_logout_confirm_title = 'تسجيل الخروج';
String a_logout_confirm_message = 'هل تريد تسجيل الخروج؟';
String a_final_confirm_title = 'تأكيد نهائي';
String a_logout_final_message = 'هل أنت متأكد من أنك تريد تسجيل الخروج؟';
String a_exit_app_title = 'خروج من التطبيق';
String a_exit_app_message = 'هل تريد الخروج من التطبيق؟';
String a_exit_app_final_message = 'هل أنت متأكد من أنك تريد الخروج من التطبيق؟';
String a_cancel = 'إلغاء';
String a_yes = 'نعم';
String a_confirm = 'تأكيد';
String a_exit = 'خروج';

// ShowProduct نصوص
String a_add_to_favorite = 'إضافة إلى المفضلة';
String a_remove_from_favorite = 'حذف من المفضلة';
String a_readd_to_favorite = 'إعادة الإضافة';
String a_likes_count = 'عدد المعجبين';
String a_product_details = 'تفاصيل المنتج';
String a_product_price = 'سعر المنتج';
String a_product_status = 'حالة المنتج';
String a_available = 'متوفر';
String a_not_available = 'غير متوفر';

// ShowProduct رسائل
String a_product_added_already = 'المنتج مضاف مسبقاً';
String a_error_occurred = 'حدث خطأ';
String a_loading_data = 'جاري تحميل البيانات...';
String a_product_loaded = 'تم تحميل المنتج';
String a_favorites_loaded = 'تم تحميل المفضلات';
String a_favorite_state = 'حالة المفضلة';
String a_updating_favorite = 'جاري تحديث المفضلة';
String a_adding_new_favorite = 'جاري إضافة مفضلة جديدة';
String a_product_exists_reloading = 'المنتج موجود مسبقاً، جاري إعادة التحميل...';
String a_error_loading_data = 'خطأ في تحميل البيانات';
String a_error_loading_favorites = 'تحذير: تعذر تحميل المفضلات';
String a_error_updating_likes = 'خطأ في تحديث عدد الإعجابات';
String a_error_in_favorite_action = 'خطأ في إجراء المفضلة';

String my_store_l='متاجري';
String my_announce_l='إعلاناتي';

String availability_status ='حالة التوفر';
String error_store_loading_data_m='فشل تحميل بيانات المتجر';
String error_update_data_m='حدث خطأ أثناء التحديث';
String product_activated_m='تم تفعيل توفر المنتج';
String product_activated_no_m='تم إلغاء توفر المنتج';
String delete_product_m='تم حذف المنتج بنجاح';
String error_delete_product_m='فشل حذف المنتج';
String a_confirm_end_l='تأكيد نهائي';
String delete_product_end_l='هل أنت متأكد من أنك تريد حذف هذا المنتج؟ لا يمكن التراجع عن هذه العملية.';
String a_confirm_delete_l='تأكيد الحذف';
String delete_product_q_l='هل تريد حذف هذا المنتج؟';

// AddAnnouncement نصوص
String a_announcement_note_label = 'نص الإعلان';
String a_announcement_image_label = 'صورة الإعلان';
String a_please_enter_announcement_text = 'رجاء ادخال نص الإعلان';
String a_announcement_max_length_error = 'لا يجوز أن يكون الإعلان أكثر من 60 محرف';
String a_please_enter_announcement_image = 'رجاء ادخال صورة الإعلان';
String a_pick_image_button = 'اختيار صورة';
String a_adding_loading_text = 'جاري الإضافة...';
String a_announcement_added_success = 'تم إضافة الإعلان بنجاح!';
String a_announcement_add_failed = 'فشل في إضافة الإعلان';
String a_image_pick_failed = 'فشل في اختيار الصورة';
String a_image_required = 'يجب اختيار صورة للإعلان';

// Login نصوص
String a_invalid_email_error = 'البريد الإلكتروني غير صالح';
String a_reset_password_via_email = 'نغير كلمة المرور باستخدام البريد الإلكتروني';
String a_login_failed = 'فشل تسجيل الدخول';
String a_email_not_registered = 'البريد الإلكتروني غير مسجل في النظام';
String a_account_banned = 'الحساب محظور. يرجى التواصل مع الدعم';
String a_invalid_credentials = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
String a_unexpected_error = 'حدث خطأ غير متوقع';
String a_user_data_failed = 'فشل في تكوين بيانات المستخدم';
String a_login_success = 'تم تسجيل الدخول بنجاح';
String a_biometric_auth = 'المصادقة البيومترية';
String a_biometric_not_available = 'المصادقة البيومترية غير متاحة';
String a_try_again = 'حاول مرة أخرى';

String image_selected_ann ='يجب اختيار صورة للإعلان';

// AddProduct نصوص
String a_product_type_label = 'نوع المنتج';
String a_please_enter_product_name = 'يرجى ادخال اسم المنتج';
String a_please_select_product_type = 'يرجى اختيار نوع المنتج';
String a_please_enter_product_overview = 'يرجى ادخال لمحة عن المنتج';
String a_please_enter_product_price = 'يرجى ادخال سعر المنتج';
String a_please_enter_product_image = 'يرجى ادخال صورة المنتج';
String a_select_image_button = 'اختيار صورة';
String a_no_image_selected = 'لم يتم اختيار صورة';
String a_image_too_large = 'حجم الصورة كبير جداً';
String a_please_select_product_image = 'يرجى اختيار صورة للمنتج';
String a_product_added_success = 'تم إضافة المنتج بنجاح';
String a_product_add_failed = 'فشل في إضافة المنتج';

// AddStore نصوص
String a_store_type_label = 'نوع المتجر';
String a_please_enter_store_name = 'يرجى ادخال اسم المتجر';
String a_please_select_store_type = 'يرجى اختيار نوع المتجر';
String a_please_enter_store_overview = 'يرجى ادخال لمحة عن المتجر';
String a_please_enter_store_phone = 'يرجى ادخال رقم الهاتف';
String a_please_enter_store_location = 'يرجى ادخال موقع المتجر';
String a_please_enter_store_image = 'يرجى ادخال صورة المتجر';
String a_store_added_success = 'تم إضافة المتجر بنجاح ';
String a_store_add_failed = 'فشل في إضافة المتجر';
String a_failed_to_load_categories = 'فشل في تحميل الفئات';
String a_operation_failed = 'فشل العملية';
String a_loading_categories_failed = 'فشل في تحميل الفئات';

// AnnouncementScreen نصوص
String a_search_announcement_hint = 'بحث عن إعلان أو متجر';
String a_choose_date_range = 'اختر نطاق زمني';
String a_clear_filter = 'مسح الفلترة';
String a_selected_date_range = 'النطاق الزمني المحدد:';
String a_start_date = 'تاريخ البداية';
String a_end_date = 'تاريخ النهاية';
String a_date_range_selected = 'تم تحديد النطاق الزمني بنجاح!';
String a_no_announcements = 'لا توجد إعلانات حالياً';
String a_announcements_loading_error = 'خطأ في جلب الإعلانات';
String a_date_conversion_error = 'خطأ في تحويل التاريخ';
String a_store_not_found = 'متجر غير معروف';
String a_date_range_confirmation = 'تم تحديد النطاق الزمني بنجاح!';
String a_start_date_selected = 'تم تحديد تاريخ البداية';
String a_end_date_selected = 'تم تحديد تاريخ النهاية';

// MyAnnouncement نصوص
String a_my_announcements_title = 'إعلاناتي';
String a_delete_announcement_confirm = 'تأكيد الحذف';
String a_delete_announcement_question = 'هل تريد حذف هذا الإعلان؟';
String a_announcement_deleted_success = 'تم حذف الإعلان بنجاح';
String a_announcement_delete_failed = 'فشل حذف الإعلان';
String a_edit_option = 'تعديل';
String a_delete_option = 'حذف';
String a_view_store_tooltip = 'عرض المتجر';

// ChekPasswordCode نصوص
String a_enter_code_sent_to = 'ادخل الكود المرسل إلى';
String a_check_your_email = 'تحقق من بريدك الإلكتروني للحصول على كود التحقق';
String a_verification_code = 'كود التحقق';
String a_enter_verification_code = 'ادخل كود التحقق';
String a_confirm_code = 'تأكيد الكود';
String a_verifying = 'جاري التحقق...';
String a_code_verified_success = 'تم التحقق بنجاح';
String a_invalid_code = 'كود التحقق غير صحيح';
String a_incorrect_data = 'بيانات غير صحيحة';
String a_server_error = 'حدث خطأ في الخادم';
String a_connection_error = 'خطأ في الاتصال';
String a_server_returns_invalid_data = 'الخادم يعيد بيانات غير صحيحة';
String a_please_enter_verification_code = 'يرجى إدخال كود التحقق';

// CreateUser نصوص
String a_store_owner_label = 'صاحب مشروع';
String a_password_too_short = 'يجب ان تكون كلمة المرور اطول من 8 محارف';
String a_account_created_success = 'تم إنشاء الحساب بنجاح';
String a_fingerprint_not_supported = 'جهازك لا يدعم المصادقة بالبصمة';
String a_touch_sensor_to_register = 'المس مستشعر البصمة للتسجيل';
String a_fingerprint_registered_success = 'تم تسجيل البصمة بنجاح';
String a_fingerprint_error = 'حدث خطأ في البصمة';
String a_user_data_save_failed = 'فشل في حفظ بيانات المستخدم محلياً';
String a_user_data_saved = 'تم حفظ بيانات المستخدم في الذاكرة المحلية';
String a_invalid_email_format = 'البريد الإلكتروني غير صالح';

// EditAnnouncement نصوص
String a_edit_announcement_title = 'تعديل إعلان';
String a_announcement_updated_success = 'تم تعديل الإعلان بنجاح!';
String a_announcement_update_failed = 'فشل في تعديل الإعلان';

// EditProduct نصوص
String a_product_updated_success = 'تم تحديث المنتج بنجاح';
String a_product_update_failed = 'فشل في تحديث المنتج';

// EditProfile نصوص
String a_please_enter_full_name = 'يرجى ادخال اسمك الكامل';
String a_profile_updated_success = 'تم تعديل الحساب بنجاح';
String a_profile_update_failed = 'فشل التعديل';
String a_profile_update_error = 'خطأ أثناء تعديل المستخدم';

// EditStore نصوص
String a_loading_classes = 'جاري التحميل...';
String a_store_updated_success = 'تم تعديل المتجر بنجاح ';
String a_store_update_failed = 'حدث خطأ أثناء التعديل ';
String a_server_response_error = 'خطأ في معالجة الاستجابة من الخادم';
String a_error_fetching_categories = 'خطأ أثناء جلب الأصناف';

String a_no_favorites_message = 'لا توجد منتجات في المفضلة';

// إضافة هذه المتغيرات
String a_send_code = 'إرسال الكود';
String a_enter_email_for_code = 'ادخل بريدك الإلكتروني لإرسال كود التحقق';
String a_email_notfound = 'البريد الإلكتروني غير موجود';

String my_stores_not_found='لا توجد متاجر متاحة';

String product_search="بحث عن منتج";

String product_all='كل المنتجات';

String products_not_found='لا توجد منتجات';

String user_ann="إعلانات المستخدم";

// إضافة هذه المتغيرات
String a_reset_password_title = 'تعيين كلمة المرور الجديدة';
String a_new_password = 'كلمة المرور الجديدة';
String a_confirm_password = 'تأكيد كلمة المرور';
String a_confirm_password_m = 'يرجى تأكيد كلمة المرور';
String a_passwords_not_match = 'كلمتا المرور غير متطابقتين';
String a_change_password = 'تغيير';
String a_password_reset_success = 'تم تغيير كلمة المرور بنجاح';
String a_password_reset_failed = 'فشل تغيير كلمة المرور';
String erorr_html="حدث خطأ في الخادم (صفحة HTML)";

// إضافة هذه المتغيرات
String a_delete_user = 'حذف المستخدم';
String a_delete_user_question = 'هل تريد حذف هذا المستخدم؟';
String a_delete_user_final_warning = 'هل أنت متأكد من أنك تريد حذف هذا المستخدم؟ لا يمكن التراجع عن هذه العملية.';
String a_user_deleted_success = 'تم حذف المستخدم بنجاح';
String a_user_delete_failed = 'فشل حذف المستخدم';

// إضافة هذه المتغيرات
String a_all_users = 'كل المستخدمين';
String a_search_users = 'بحث بالاسم أو الإيميل';
String a_no_users_found = 'لا يوجد مستخدمين';
String a_user_type_admin = 'مدير';
String a_user_type_store_owner = 'صاحب متجر';
String a_user_type_regular = 'زائر';
String a_user_type_default = 'مستخدم';
String a_data_loading_error = 'خطأ في جلب بيانات';

// إضافة هذه المتغيرات
String a_delete_store = 'حذف المتجر';
String a_delete_store_question = 'هل تريد حذف هذا المتجر؟';
String a_delete_store_final_warning = 'هل أنت متأكد من أنك تريد حذف هذا المتجر؟ لا يمكن التراجع عن هذه العملية.';
String a_store_deleted_success = 'تم حذف المتجر بنجاح';
String a_store_delete_failed = 'فشل حذف المتجر';
String a_more_options = 'المزيد من الخيارات';
String a_unknown_category = 'غير معروف';

String a_no_stores_available = 'لا توجد متاجر حالياً';
String a_all_stores = 'كل المتاجر';

String a_loading_categories = 'جاري تحميل الفئات...';

String comment_t = "التعليقات";
String prodect_t =  "المنتج";
String comment_you = 'اكتب تعليقك...';
String comment_no = 'لا توجد تعليقات بعد';


String app_name = 'Dukkani';

//الصور
var image_logo_s = Image.asset('assets/images/img_5.png', height: 30, width: 30);
var image_logo_w = Image.asset('assets/images/img_4.png', height: 60);
var image_login = Image.asset('assets/images/img.png', height: 250);
var image_logo_b = Image.asset('assets/images/img_5.png', height: 160);
var image_user = Image.asset('assets/images/img_3.png', height: 60);
var image_first_launch = Image.asset('assets/images/img_6.png', height: 250);
var image_restpassword = Image.asset('assets/images/img_7.png', height: 250);
const String image_user_path = 'assets/images/img_3.png';



// في ملف variables.dart - أضف هذه الدوال في النهاية

// دالة لترجمة أسماء الأصناف
String translateCategoryName(Map<String, dynamic> category) {
  if (language_app == "ar") {
    return category['class_name'] ?? 'غير معروف';
  } else {
    return category['class_name_english'] ?? category['class_name'] ?? 'Unknown';
  }
}

// دالة لترجمة أسماء الأنواع
String translateTypeName(Map<String, dynamic> type) {
  if (language_app == "ar") {
    return type['type_name'] ?? 'غير معروف';
  } else {
    return type['type_name_english'] ?? type['type_name'] ?? 'Unknown';
  }
}

// دالة عامة للترجمة
String getTranslatedName(dynamic item) {
  if (item is Map<String, dynamic>) {
    if (item.containsKey('class_name')) {
      return translateCategoryName(item);
    } else if (item.containsKey('type_name')) {
      return translateTypeName(item);
    }
  }
  return item.toString();
}