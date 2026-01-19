import 'dart:ui';
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
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;

    await auth.login(_email.text.trim(), _password.text.trim());
    if (!mounted) return;

    if (auth.errorMessage == null && auth.user != null) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  Future<void> _google(AuthProvider auth) async {
    await auth.signInWithGoogle();
    if (!mounted) return;

    if (auth.errorMessage == null && auth.user != null) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
          // Background
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
                  // Top bar
                  Row(
                    children: [
                      _CircleBackButton(onTap: () => Navigator.pop(context)),
                      const Spacer(),
                    ],
                  ),
                  SizedBox(height: 18.h),

                  // Header
                  Text(
                    AppStrings.t(context, 'login_welcome'),
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

                  // Glass Card
                  _GlassCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _ProField(
                            label: AppStrings.t(context, 'email'),
                            hint: 'name@example.com',
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
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
                          _ProField(
                            label: AppStrings.t(context, 'password'),
                            hint: '••••••••',
                            controller: _password,
                            obscureText: _obscure,
                            prefixIcon: Icons.lock_outline,
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
                              if (v == null || v.isEmpty) {
                                return AppStrings.t(
                                  context,
                                  'login_error_empty_password',
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
                              onPressed: auth.loading
                                  ? null
                                  : () => _login(auth),
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
                                        AppStrings.t(context, 'login_button'),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                              ),
                            ),
                          ),

                          SizedBox(height: 14.h),

                          _OrDivider(text: AppStrings.t(context, 'login_or')),

                          SizedBox(height: 14.h),

                          SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: OutlinedButton.icon(
                              onPressed: auth.loading
                                  ? null
                                  : () => _google(auth),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                side: BorderSide(
                                  color: cs.primary.withOpacity(0.35),
                                ),
                              ),
                              icon: Image.asset(
                                'assets/google.png',
                                height: 20.h,
                                width: 20.w,
                              ),
                              label: Text(
                                AppStrings.t(context, 'login_continue_google'),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w800,
                                  color: theme.textTheme.bodyMedium?.color,
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
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignupPage()),
                        );
                      },
                      child: Text(
                        "${AppStrings.t(context, 'login_no_account')} ${AppStrings.t(context, 'login_create_account')}",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
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

// ---------- UI Components ----------
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

class _OrDivider extends StatelessWidget {
  final String text;
  const _OrDivider({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(child: Divider(color: theme.dividerColor.withOpacity(0.6))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
            ),
          ),
        ),
        Expanded(child: Divider(color: theme.dividerColor.withOpacity(0.6))),
      ],
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
