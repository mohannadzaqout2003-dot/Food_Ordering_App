import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/localization/app_string.dart';
import 'package:restaurant_app/provider/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();

    if (!_formKey.currentState!.validate()) return;

    await auth.register(_email.text.trim(), _password.text.trim());

    if (!mounted) return;

    if (auth.errorMessage != null) {
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final firstName = _firstName.text.trim();
      final lastName = _lastName.text.trim();
      final phone = _phone.text.trim();
      final fullName =
          lastName.isNotEmpty ? '$firstName $lastName' : firstName;

      await user.updateDisplayName(fullName);

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'email': user.email,
        'photoUrl': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await context.read<AuthProvider>().refreshUser();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.t(context, 'signup_success'),
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppStrings.t(context, 'edit_profile_error_generic')}: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.t(context, 'signup_title')),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _firstName,
                  decoration: InputDecoration(
                    labelText: AppStrings.t(
                      context,
                      'signup_first_name',
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return AppStrings.t(
                        context,
                        'signup_error_empty_first_name',
                      );
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),

                TextFormField(
                  controller: _lastName,
                  decoration: InputDecoration(
                    labelText: AppStrings.t(
                      context,
                      'signup_last_name',
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: AppStrings.t(
                      context,
                      'signup_phone',
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: AppStrings.t(context, 'signup_email'),
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
                        'signup_error_invalid_email',
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
                    labelText: AppStrings.t(
                      context,
                      'signup_password',
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.length < 6) {
                      return AppStrings.t(
                        context,
                        'signup_error_password_short',
                      );
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                if (auth.errorMessage != null)
                  Text(
                    auth.errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),

                SizedBox(height: 16.h),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.loading ? null : _submit,
                    child: auth.loading
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            AppStrings.t(context, 'signup_button'),
                            style: TextStyle(fontSize: 14.sp),
                          ),
                  ),
                ),

                SizedBox(height: 20.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.t(context, 'signup_have_account'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppStrings.t(context, 'signup_login_here'),
                        style: TextStyle(fontSize: 13.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
