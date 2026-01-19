import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/language_provider.dart';

class AppStrings {
  // ================= ENGLISH =================
  static const Map<String, String> _en = {
    // ===== General =====
    'app_title': 'Food App',

    // ===== Bottom Nav =====
    'nav_home': 'Home',
    'nav_favorites': 'Favorites',
    'nav_orders': 'Orders',
    'nav_profile': 'Profile',

    // ===== Auth - Login =====
    'login_title': 'Login',
    'login_welcome': 'Welcome back',
    'login_subtitle': 'Log in to continue ordering your favorite meals.',
    'login_button': 'Sign In',
    'login_or': 'OR',
    'login_continue_google': 'Continue with Google',
    'login_no_account': "Don't have an account?",
    'login_create_account': 'Create Account',

    'email': 'Email',
    'password': 'Password',
    'logout': 'Logout',

    'login_error_empty_email': 'Enter the email',
    'login_error_invalid_email': 'Enter a valid email',
    'login_error_empty_password': 'Enter the password',

    // ===== Auth - Signup =====
    'signup_title': 'Create Account',
    'signup_first_name': 'First Name',
    'signup_last_name': 'Last Name',
    'signup_phone': 'Phone',
    'signup_email': 'Email',
    'signup_password': 'Password',
    'signup_button': 'Create Account',
    'signup_have_account': 'Already have an account?',
    'signup_login_here': 'Login',
    'signup_success': 'Account created successfully',
    'signup_error_empty_first_name': 'Enter your first name',
    'signup_error_password_short': 'Password must be at least 6 characters',
    'signup_error_invalid_email': 'Enter a valid email',

    // ===== Home =====
    'home_location': 'Location',
    'home_place_name': 'Place Name',
    'home_search_hint': 'Search your groceries',
    'home_discount_title': 'Get 35% Discount',
    'home_discount_subtitle': 'on your first order from app.',
    'home_shop_now': 'Shop Now',
    'home_no_products': 'No products in this category.',
    'home_added_to_cart': 'added to cart',

    // ===== Cart =====
    'cart_title': 'My Cart',
    'cart_empty': 'Your cart is empty',
    'cart_total': 'Total:',
    'cart_subtotal': 'Subtotal',
    'cart_checkout': 'Checkout',
    'cart_empty_error': 'Cart is empty',
    'cart_login_required': 'Please login first',
    'cart_order_success': 'Order placed successfully',
    'cart_order_failed': 'Failed to place order',

    // ===== Orders =====
    'orders_title': 'My Orders',
    'orders_empty': 'You have no orders yet.',
    'orders_status_completed': 'Completed',
    'orders_unknown_date': 'Unknown date',
    'orders_items_label': 'Items',

    // ===== Order Details =====
    'order_details_summary': 'Order Summary',
    'order_details_date': 'Date:',
    'order_details_total': 'Total:',
    'order_details_items': 'Items',

    // ===== Favorites =====
    'favorites_title': 'My Favorites',
    'favorites_empty_title': 'You have no favorites yet.',
    'favorites_empty_subtitle': 'Browse meals and tap the heart to save them.',
    'favorites_search_hint': 'Search your favorites',
    'favorites_add_to_cart': 'Add to Cart',

    // ===== Profile =====
    'profile_title': 'Profile',
    'profile_my_profile': 'My Profile',
    'profile_account': 'Account',
    'profile_statistics': 'Statistics',
    'profile_appearance': 'Appearance',
    'profile_dark_mode': 'Dark Mode',
    'profile_edit_profile': 'Edit Profile',
    'profile_change_password': 'Change Password',
    'profile_logout': 'Logout',
    'profile_language': 'Language',
    'no_user_logged_in': 'No user logged in',
    'profile_user_id': 'User ID',
    'profile_orders_label': 'Orders',
    'profile_favorites_label': 'Favorites',
    'profile_settings': 'Settings',
    'profile_my_orders_menu': 'My Orders',
    'profile_my_favorites_menu': 'My Favorites',
    'profile_terms': 'Terms & Conditions',
    'profile_terms_coming_soon': 'Terms & Conditions page coming soon',
    'profile_logout_confirm_title': 'Log Out',
    'profile_logout_confirm_message': 'Are you sure you want to log out?',
    'profile_logout_cancel': 'Cancel',
    'profile_logout_yes': 'Yes',
    'profile_mobile_label': 'Mobile',

    // ===== Change Password =====
    'change_password_title': 'Change Password',
    'change_password_subtitle':
        'For your account security, please enter your current password first.',
    'change_password_current': 'Current password',
    'change_password_new': 'New password',
    'change_password_confirm': 'Confirm new password',
    'change_password_save': 'Save & Update',
    'change_password_error_no_user': 'No user is logged in.',
    'change_password_success': 'Password updated successfully',
    'change_password_error_wrong_password': 'Current password is incorrect.',
    'change_password_error_weak_password': 'New password is too weak.',
    'change_password_error_requires_recent_login':
        'Please log in again and try changing the password.',
    'change_password_error_generic': 'Failed to change password.',

    // ===== Edit Profile =====
    'edit_profile_title': 'Edit Profile',
    'edit_profile_first_name': 'First Name',
    'edit_profile_last_name': 'Last Name',
    'edit_profile_phone': 'Phone',
    'edit_profile_save': 'Save & Update',
    'edit_profile_error_first_name_empty': 'First name cannot be empty',
    'edit_profile_success': 'Profile updated successfully',
    'edit_profile_error_generic': 'Error while saving profile',

    // Terms & Conditions
    'terms_title': 'Terms & Conditions',
    'terms_intro':
        'By using this application, you agree to the following terms and conditions. Please read them carefully.',

    'terms_section_account_title': '1. Account & Registration',
    'terms_section_account_body':
        'You must provide accurate and complete information when creating your account. '
        'You are responsible for keeping your login credentials secure and not sharing them with others.',

    'terms_section_orders_title': '2. Orders & Payments',
    'terms_section_orders_body':
        'All orders placed through the app are subject to confirmation. '
        'Some orders may be canceled or modified based on availability. '
        'Prices may change without prior notice.',

    'terms_section_data_title': '3. Privacy & Data',
    'terms_section_data_body':
        'We may collect some basic information to improve your experience, such as your name, email, and order history. '
        'We will not share your personal data with third parties except as required by law.',

    'terms_section_contact_title': '4. Support & Contact',
    'terms_section_contact_body':
        'If you face any issue while using the app, you can contact our support team. '
        'We will do our best to help you and solve your problem as soon as possible.',

    // ===== Notifications =====
    'notifications_title': 'Notifications',
    'notifications_empty': 'No notifications yet.',
    'notifications_mark_all': 'Mark all as read',
    'notifications_clear_all': 'Clear all',
    'notifications_all_marked': 'All notifications marked as read',
    'notifications_all_cleared': 'All notifications cleared',
    'notifications_deleted': 'Notification deleted',

    'notification_order_title': 'Order placed',
    'notification_order_body':
        'Your order has been placed successfully. You can track it from the Orders page.',

    //onboardin page
    'onboarding_slide_1_title': 'Welcome to Food App',
    'onboarding_slide_1_description':
        'Discover delicious meals, delivered to your door.',
    'onboarding_slide_2_title': 'Easy Ordering',
    'onboarding_slide_2_description':
        'Order your favorite meals in a few simple steps.',
    'onboarding_slide_3_title': 'Track Your Orders',
    'onboarding_slide_3_description': 'Get real-time updates on your orders.',
    'onboarding_next': 'Next',
    'onboarding_skip': 'Skip',
    'onboarding_done': 'Done',

    // ===== Payment =====
    'payment_title': 'Payment',
    'payment_select_method': 'Select a payment method',
    'payment_summary': 'Payment summary',
    'payment_cash_on_delivery': 'Cash on delivery',
    'payment_card_simulation': 'Card (Simulation)',
    'payment_place_order': 'Place order',
    'payment_method_label': 'Payment method',
    'payment_test_badge': 'Test',
    'payment_selected': 'Selected',
    'payment_select': 'Select',

    // ===== Product Details =====
    'product_details_title': 'Product details',
    'product_details_prep': 'Prep',
    'product_details_energy': 'Energy',
    'product_details_size': 'Size',
    'product_details_items': 'Items',
    'product_details_quantity': 'Quantity',
    'product_details_total': 'Total',
    'product_details_add_to_cart': 'Add to cart',
    'product_details_placeholder': '{name} description is not available yet.',
    'product_details_nearby': 'Nearby',
  };

  // ================= ARABIC =================
  static const Map<String, String> _ar = {
    // ===== General =====
    'app_title': 'تطبيق الطعام',

    // ===== Bottom Nav =====
    'nav_home': 'الرئيسية',
    'nav_favorites': 'المفضلة',
    'nav_orders': 'الطلبات',
    'nav_profile': 'الملف الشخصي',

    // ===== Auth - Login =====
    'login_title': 'تسجيل الدخول',
    'login_welcome': 'مرحبًا بعودتك',
    'login_subtitle': 'سجّل دخولك لمتابعة طلب وجباتك المفضلة.',
    'login_button': 'دخول',
    'login_or': 'أو',
    'login_continue_google': 'المتابعة باستخدام Google',
    'login_no_account': 'ليس لديك حساب؟',
    'login_create_account': 'إنشاء حساب جديد',

    'email': 'البريد الإلكتروني',
    'password': 'كلمة المرور',
    'logout': 'تسجيل الخروج',

    // ===== Auth - Login Errors =====
    'login_error_empty_email': 'أدخل البريد الإلكتروني',
    'login_error_invalid_email': 'أدخل بريدًا إلكترونيًا صالحًا',
    'login_error_empty_password': 'أدخل كلمة المرور',

    // ===== Auth - Signup =====
    'signup_title': 'إنشاء حساب',
    'signup_first_name': 'الاسم الأول',
    'signup_last_name': 'اسم العائلة',
    'signup_phone': 'رقم الجوال',
    'signup_email': 'البريد الإلكتروني',
    'signup_password': 'كلمة المرور',
    'signup_button': 'إنشاء حساب',
    'signup_have_account': 'لديك حساب بالفعل؟',
    'signup_login_here': 'تسجيل الدخول',
    'signup_success': 'تم إنشاء الحساب بنجاح',
    'signup_error_empty_first_name': 'أدخل اسمك الأول',
    'signup_error_password_short': 'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
    'signup_error_invalid_email': 'أدخل بريدًا إلكترونيًا صالحًا',

    // ===== Home =====
    'home_location': 'الموقع',
    'home_place_name': 'اسم المكان',
    'home_search_hint': 'ابحث عن المنتجات',
    'home_discount_title': 'احصل على خصم 35%',
    'home_discount_subtitle': 'على أول طلب لك من التطبيق.',
    'home_shop_now': 'تسوق الآن',
    'home_no_products': 'لا توجد منتجات في هذه الفئة.',
    'home_added_to_cart': 'تمت إضافته إلى السلة',
    // ===== Product Details =====
    'product_details_title': 'تفاصيل المنتج',
    'product_details_prep': 'التحضير',
    'product_details_energy': 'السعرات',
    'product_details_size': 'الحجم',
    'product_details_items': 'الوصف',
    'product_details_quantity': 'الكمية',
    'product_details_total': 'الإجمالي',
    'product_details_add_to_cart': 'أضف للسلة',
    'product_details_placeholder': 'وصف {name} غير متوفر حالياً.',
    'product_details_nearby': 'قريب',

    // ===== Cart =====
    'cart_title': 'سلة المشتريات',
    'cart_empty': 'سلتك فارغة',
    'cart_total': 'الإجمالي:',
    'cart_subtotal': 'المجموع الفرعي',
    'cart_checkout': 'إتمام الشراء',
    'cart_empty_error': 'السلة فارغة',
    'cart_login_required': 'يرجى تسجيل الدخول أولاً',
    'cart_order_success': 'تم إرسال الطلب بنجاح',
    'cart_order_failed': 'فشل في إرسال الطلب',

    // ===== Orders =====
    'orders_title': 'طلباتي',
    'orders_empty': 'لا توجد طلبات حتى الآن.',
    'orders_status_completed': 'مكتمل',
    'orders_unknown_date': 'تاريخ غير معروف',
    'orders_items_label': 'العناصر',

    // ===== Order Details =====
    'order_details_summary': 'ملخص الطلب',
    'order_details_date': 'التاريخ:',
    'order_details_total': 'الإجمالي:',
    'order_details_items': 'العناصر',

    // ===== Favorites =====
    'favorites_title': 'مفضلتي',
    'favorites_empty_title': 'لا توجد عناصر مفضلة بعد.',
    'favorites_empty_subtitle': 'تصفّح الوجبات واضغط على رمز القلب لحفظها.',
    'favorites_search_hint': 'ابحث في المفضلة',
    'favorites_add_to_cart': 'أضف إلى السلة',

    // ===== Profile =====
    'profile_title': 'الملف الشخصي',
    'profile_my_profile': 'ملفي الشخصي',
    'profile_account': 'الحساب',
    'profile_statistics': 'الإحصائيات',
    'profile_appearance': 'المظهر',
    'profile_dark_mode': 'الوضع الداكن',
    'profile_edit_profile': 'تعديل الملف الشخصي',
    'profile_change_password': 'تغيير كلمة المرور',
    'profile_logout': 'تسجيل الخروج',
    'profile_language': 'اللغة',
    'no_user_logged_in': 'لا يوجد مستخدم مسجَّل الدخول',
    'profile_user_id': 'معرّف المستخدم',
    'profile_orders_label': 'الطلبات',
    'profile_favorites_label': 'المفضلة',
    'profile_settings': 'الإعدادات',
    'profile_my_orders_menu': 'طلباتي',
    'profile_my_favorites_menu': 'مفضلتي',
    'profile_terms': 'الشروط والأحكام',
    'profile_terms_coming_soon': 'صفحة الشروط والأحكام قيد الإعداد',
    'profile_logout_confirm_title': 'تسجيل الخروج',
    'profile_logout_confirm_message': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
    'profile_logout_cancel': 'إلغاء',
    'profile_logout_yes': 'نعم',
    'profile_mobile_label': 'الجوال',

    // ===== Change Password =====
    'change_password_title': 'تغيير كلمة المرور',
    'change_password_subtitle':
        'لأمان حسابك، يرجى إدخال كلمة المرور الحالية أولاً.',
    'change_password_current': 'كلمة المرور الحالية',
    'change_password_new': 'كلمة المرور الجديدة',
    'change_password_confirm': 'تأكيد كلمة المرور الجديدة',
    'change_password_save': 'حفظ وتحديث',
    'change_password_error_no_user': 'لا يوجد مستخدم مسجَّل الدخول.',
    'change_password_success': 'تم تحديث كلمة المرور بنجاح',
    'change_password_error_wrong_password': 'كلمة المرور الحالية غير صحيحة.',
    'change_password_error_weak_password': 'كلمة المرور الجديدة ضعيفة جدًا.',
    'change_password_error_requires_recent_login':
        'يرجى تسجيل الدخول مرة أخرى ثم المحاولة.',
    'change_password_error_generic': 'فشل في تغيير كلمة المرور.',

    // ===== Edit Profile =====
    'edit_profile_title': 'تعديل الملف الشخصي',
    'edit_profile_first_name': 'الاسم الأول',
    'edit_profile_last_name': 'اسم العائلة',
    'edit_profile_phone': 'رقم الجوال',
    'edit_profile_save': 'حفظ التعديلات',
    'edit_profile_error_first_name_empty': 'لا يمكن أن يكون الاسم الأول فارغًا',
    'edit_profile_success': 'تم تحديث الملف الشخصي بنجاح',
    'edit_profile_error_generic': 'حدث خطأ أثناء حفظ البيانات',

    'terms_title': 'الشروط والأحكام',
    'terms_intro':
        'باستخدامك لهذا التطبيق، فإنك توافق على الشروط والأحكام التالية. يرجى قراءتها بعناية.',

    'terms_section_account_title': '1. الحساب والتسجيل',
    'terms_section_account_body':
        'يجب عليك إدخال معلومات صحيحة وكاملة عند إنشاء حسابك. '
        'أنت مسؤول عن الحفاظ على سرية بيانات تسجيل الدخول وعدم مشاركتها مع الآخرين.',

    'terms_section_orders_title': '2. الطلبات والدفع',
    'terms_section_orders_body':
        'جميع الطلبات التي يتم إجراؤها من خلال التطبيق خاضعة للتأكيد. '
        'قد يتم إلغاء بعض الطلبات أو تعديلها بناءً على التوافر. '
        'قد تتغير الأسعار دون إشعار مسبق.',

    'terms_section_data_title': '3. الخصوصية والبيانات',
    'terms_section_data_body':
        'قد نقوم بجمع بعض المعلومات الأساسية لتحسين تجربتك، مثل اسمك وبريدك الإلكتروني وسجل طلباتك. '
        'لن نقوم بمشاركة بياناتك الشخصية مع أي طرف ثالث إلا إذا تطلّب القانون ذلك.',

    'terms_section_contact_title': '4. الدعم والتواصل',
    'terms_section_contact_body':
        'إذا واجهتك أي مشكلة أثناء استخدام التطبيق، يمكنك التواصل مع فريق الدعم. '
        'سنبذل قصارى جهدنا لمساعدتك وحل مشكلتك في أسرع وقت ممكن.',

    // ===== Notifications =====
    'notifications_title': 'الإشعارات',
    'notifications_empty': 'لا توجد إشعارات حتى الآن.',
    'notifications_mark_all': 'تحديد الكل كمقروء',
    'notifications_clear_all': 'مسح جميع الإشعارات',
    'notifications_all_marked': 'تم تحديد جميع الإشعارات كمقروءة',
    'notifications_all_cleared': 'تم مسح جميع الإشعارات',
    'notifications_deleted': 'تم حذف الإشعار',

    'notification_order_title': 'تم إرسال الطلب',
    'notification_order_body':
        'تم إرسال طلبك بنجاح، يمكنك متابعة حالة الطلب من صفحة الطلبات.',

    // ===== Payment =====
    'payment_title': 'الدفع',
    'payment_select_method': 'اختر طريقة الدفع',
    'payment_summary': 'ملخص الدفع',
    'payment_cash_on_delivery': 'الدفع عند الاستلام',
    'payment_card_simulation': 'بطاقة (تجريبي)',
    'payment_place_order': 'تأكيد الطلب',
    'payment_method_label': 'طريقة الدفع',
    'payment_test_badge': 'تجريبي',
    'payment_selected': 'محدد',
    'payment_select': 'اختيار',
    // onboarding page
    'onboarding_slide_1_title': 'مرحبًا في تطبيق الطعام',
    'onboarding_slide_1_description': 'اكتشف وجبات لذيذة، توصل إلى باب منزلك.',
    'onboarding_slide_2_title': 'طلب سهل',
    'onboarding_slide_2_description': 'اطلب وجباتك المفضلة في خطوات بسيطة.',
    'onboarding_slide_3_title': 'تتبع طلباتك',
    'onboarding_slide_3_description': 'احصل على تحديثات فورية حول طلباتك.',
    'onboarding_next': 'التالي',
    'onboarding_skip': 'تخطي',
    'onboarding_done': 'تم',
  };

  static String t(BuildContext context, String key) {
    final isArabic = Provider.of<LanguageProvider>(
      context,
      listen: false,
    ).isArabic;

    final map = isArabic ? _ar : _en;
    return map[key] ?? key;
  }

  static String splash_title(BuildContext context) {
    return 'Food App';
  }

  static String splash_subTitle(BuildContext context) {
    return 'Discover the best food around you';
  }
}
