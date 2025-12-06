import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/localization/app_string.dart';
import 'package:restaurant_app/provider/auth_provider.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.t(context, 'login_title')),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.t(context, 'login_welcome'),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  AppStrings.t(context, 'login_subtitle'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    fontSize: 13.sp,
                  ),
                ),

                SizedBox(height: 24.h),

                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AppStrings.t(context, 'email'),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return AppStrings.t(
                        context,
                        'login_error_empty_email',
                      );
                    }
                    if (!v.contains('@')) {
                      return AppStrings.t(
                        context,
                        'login_error_invalid_email',
                      );
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),

                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: AppStrings.t(context, 'password'),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return AppStrings.t(
                        context,
                        'login_error_empty_password',
                      );
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                if (auth.errorMessage != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Text(
                      auth.errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 12.sp),
                    ),
                  ),

                SizedBox(height: 8.h),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.loading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              await auth.login(
                                _email.text.trim(),
                                _password.text.trim(),
                              );

                              if (!mounted) return;

                              if (auth.errorMessage == null &&
                                  auth.user != null) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/',
                                  (route) => false,
                                );
                              }
                            }
                          },
                    child: auth.loading
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            AppStrings.t(context, 'login_button'),
                            style: TextStyle(fontSize: 14.sp),
                          ),
                  ),
                ),

                SizedBox(height: 20.h),

                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                      child: Text(
                        AppStrings.t(context, 'login_or'),
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                SizedBox(height: 20.h),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: auth.loading
                        ? null
                        : () async {
                            await auth.signInWithGoogle();

                            if (!mounted) return;

                            if (auth.errorMessage == null &&
                                auth.user != null) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/',
                                (route) => false,
                              );
                            }
                          },
                    icon: Image.asset(
                      'assets/google.png',
                      height: 20.h,
                      width: 20.w,
                    ),
                    label: auth.loading
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            AppStrings.t(
                              context,
                              'login_continue_google',
                            ),
                            style: TextStyle(fontSize: 13.sp),
                          ),
                  ),
                ),

                SizedBox(height: 20.h),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupPage()),
                    );
                  },
                  child: Text(
                    "${AppStrings.t(context, 'login_no_account')} "
                    "${AppStrings.t(context, 'login_create_account')}",
                    style: TextStyle(fontSize: 13.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
