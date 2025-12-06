
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/localization/app_string.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _loading = false;

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No user is logged in.')));
      return;
    }

    final nav = Navigator.of(context);

    setState(() => _loading = true);

    try {
      final email = user.email;
      if (email == null) {
        throw FirebaseAuthException(
          code: 'no-email',
          message: 'User has no email.',
        );
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: _currentPasswordController.text.trim(),
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(_newPasswordController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );

      nav.pop();
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'wrong-password':
          message = 'Current password is incorrect.';
          break;
        case 'weak-password':
          message = 'New password is too weak.';
          break;
        case 'requires-recent-login':
          message = 'Please log in again and try changing the password.';
          break;
        default:
          message = e.message ?? 'Failed to change password.';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar( title: Text(AppStrings.t(context, 'change_password_title')), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Update your password',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'For your account security, please enter your current password first.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),

                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: true,
                    decoration:  InputDecoration(
                      labelText: AppStrings.t(context, 'change_password_current'),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Enter your current password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration:  InputDecoration(
                      labelText: AppStrings.t(context, 'change_password_new'),
                      prefixIcon: Icon(Icons.lock_reset),
                    ),
                    validator: (v) {
                      if (v == null || v.length < 6) {
                        return 'New password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration:  InputDecoration(
                     labelText: AppStrings.t(context, 'change_password_confirm'),
                      prefixIcon: Icon(Icons.lock_person),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please confirm the new password';
                      }
                      if (v != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: _loading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                               AppStrings.t(context, 'change_password_save'),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
