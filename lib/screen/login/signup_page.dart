import 'dart:ui';
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

  bool _obscure = true;

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

    if (auth.errorMessage != null) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final firstName = _firstName.text.trim();
      final lastName = _lastName.text.trim();
      final phone = _phone.text.trim();
      final fullName = lastName.isNotEmpty ? '$firstName $lastName' : firstName;

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
          content: Text(AppStrings.t(context, 'signup_success')),
          behavior: SnackBarBehavior.floating,
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
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cs.primary.withOpacity(isDark ? 0.25 : 0.18),
                    cs.background,
                    cs.background,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _CircleBackButton(onTap: () => Navigator.pop(context)),
                      const Spacer(),
                    ],
                  ),
                  SizedBox(height: 18.h),

                  Text(
                    AppStrings.t(context, 'signup_title'),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    AppStrings.t(context, 'login_subtitle'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.7,
                      ),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 18.h),

                  _GlassCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _ProField(
                                  label: AppStrings.t(
                                    context,
                                    'signup_first_name',
                                  ),
                                  controller: _firstName,
                                  prefixIcon: Icons.person_outline,
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
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: _ProField(
                                  label: AppStrings.t(
                                    context,
                                    'signup_last_name',
                                  ),
                                  controller: _lastName,
                                  prefixIcon: Icons.person_outline,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),

                          _ProField(
                            label: AppStrings.t(context, 'signup_phone'),
                            controller: _phone,
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 12.h),

                          _ProField(
                            label: AppStrings.t(context, 'signup_email'),
                            controller: _email,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
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

                          _ProField(
                            label: AppStrings.t(context, 'signup_password'),
                            controller: _password,
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscure,
                            suffix: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
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

                          if (auth.errorMessage != null) ...[
                            SizedBox(height: 10.h),
                            _ErrorBanner(text: auth.errorMessage!),
                          ],

                          SizedBox(height: 14.h),

                          SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: ElevatedButton(
                              onPressed: auth.loading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                child: auth.loading
                                    ? SizedBox(
                                        key: const ValueKey('loading'),
                                        height: 20.h,
                                        width: 20.w,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        key: const ValueKey('text'),
                                        AppStrings.t(context, 'signup_button'),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 14.h),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.t(context, 'signup_have_account'),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            AppStrings.t(context, 'signup_login_here'),
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// reuse same UI helpers as login
class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.white.withOpacity(0.70),
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.10)
                  : Colors.black.withOpacity(0.05),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ProField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData prefixIcon;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const _ProField({
    required this.label,
    required this.controller,
    required this.prefixIcon,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffix,
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.black.withOpacity(0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String text;
  const _ErrorBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.red.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 18, color: Colors.red),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleBackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CircleBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          color: theme.cardColor.withOpacity(0.9),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
      ),
    );
  }
}
