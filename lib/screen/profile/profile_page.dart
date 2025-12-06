import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:restaurant_app/localization/app_string.dart';
import 'package:restaurant_app/provider/auth_provider.dart';
import 'package:restaurant_app/provider/category_product.dart';
import 'package:restaurant_app/provider/language_provider.dart';
import 'package:restaurant_app/provider/order_provider.dart';
import 'package:restaurant_app/provider/theme_provider.dart';
import 'package:restaurant_app/screen/profile/change_password_page.dart';
import 'package:restaurant_app/screen/profile/edit_profile_page.dart';
import 'package:restaurant_app/screen/profile/term_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OrdersProvider>().loadOrders();
    });
  }

  void _showLogoutDialog(BuildContext context, AuthProvider auth) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppStrings.t(context, 'profile_logout_confirm_title')),
        content: Text(AppStrings.t(context, 'profile_logout_confirm_message')),
        actionsPadding: const EdgeInsets.only(right: 16, left: 16, bottom: 10),
        actions: [
          SizedBox(
            width: 100,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.t(context, 'profile_logout_cancel')),
            ),
          ),
          SizedBox(
            width: 100,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              onPressed: () async {
                Navigator.pop(context);
                await auth.logout();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              },
              child: Text(AppStrings.t(context, 'profile_logout_yes')),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final lang = context.watch<LanguageProvider>();

    final ordersCount = context.watch<OrdersProvider>().orders.length;
    final favCount = context
        .watch<CategoryProduct>()
        .products
        .where((p) => p.isFavorite)
        .length;

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.user;

        if (user == null) {
          return Scaffold(
            body: Center(
              child: Text(AppStrings.t(context, 'no_user_logged_in')),
            ),
          );
        }

        final email = user.email ?? 'no-email@example.com';

        final userDocStream = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots();

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: userDocStream,
          builder: (context, snapshot) {
            String firstName = '';
            String lastName = '';
            String phone = '';

            final fallbackName = email.split('@').first;
            String fullName = user.displayName?.trim().isNotEmpty == true
                ? user.displayName!.trim()
                : fallbackName;

            if (snapshot.hasData && snapshot.data!.data() != null) {
              final data = snapshot.data!.data()!;
              firstName = (data['firstName'] ?? '').toString().trim();
              lastName = (data['lastName'] ?? '').toString().trim();
              phone = (data['phone'] ?? '').toString().trim();

              if (firstName.isNotEmpty || lastName.isNotEmpty) {
                fullName = [
                  firstName,
                  lastName,
                ].where((p) => p.isNotEmpty).join(' ');
              }
            }

            final initial = fullName.isNotEmpty
                ? fullName[0].toUpperCase()
                : '?';
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;
            final isDark = theme.brightness == Brightness.dark;
            final userIdShort = user.uid.length > 6
                ? user.uid.substring(0, 6)
                : user.uid;

            return Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: theme.scaffoldBackgroundColor,
                elevation: 0,
                centerTitle: true,
                title: Text(AppStrings.t(context, 'profile_my_profile')),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    // ---------- Header ----------
                    Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        color: isDark
                            ? colorScheme.surfaceContainerHighest.withOpacity(
                                0.4,
                              )
                            : Colors.brown[100],
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            bottom: 12,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: theme.cardColor,
                                  child: Text(
                                    initial,
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  fullName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${AppStrings.t(context, 'profile_user_id')} #$userIdShort',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.textTheme.bodySmall?.color
                                        ?.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ---------- Stats ----------
                    Row(
                      children: [
                        Expanded(
                          child: _ProfileStatChip(
                            icon: Icons.receipt_long,
                            label: AppStrings.t(
                              context,
                              'profile_orders_label',
                            ),
                            value: ordersCount.toString(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _ProfileStatChip(
                            icon: Icons.favorite,
                            label: AppStrings.t(
                              context,
                              'profile_favorites_label',
                            ),
                            value: favCount.toString(),
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _SectionHeader(AppStrings.t(context, 'profile_account')),

                    const SizedBox(height: 6),

                    _ProfileMenuTile(
                      icon: Icons.person_outline,
                      title: AppStrings.t(context, 'profile_edit_profile'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfilePage(),
                          ),
                        );
                      },
                    ),

                    _ProfileMenuTile(
                      icon: Icons.settings_outlined,
                      title: AppStrings.t(context, 'profile_settings'),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          builder: (_) {
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      themeProvider.isDark
                                          ? Icons.dark_mode
                                          : Icons.light_mode,
                                    ),
                                    title: Text(
                                      AppStrings.t(
                                        context,
                                        'profile_dark_mode',
                                      ),
                                    ),
                                    trailing: Switch(
                                      value: themeProvider.isDark,
                                      onChanged: (value) {
                                        themeProvider.toggleTheme(value);
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.lock_outline),
                                    title: Text(
                                      AppStrings.t(
                                        context,
                                        'profile_change_password',
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const ChangePasswordPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),

                    _ProfileMenuTile(
                      icon: Icons.receipt_long,
                      title: AppStrings.t(context, 'profile_my_orders_menu'),
                      onTap: () {
                        Navigator.pushNamed(context, '/orders');
                      },
                    ),

                    _ProfileMenuTile(
                      icon: Icons.favorite_border,
                      title: AppStrings.t(context, 'profile_my_favorites_menu'),
                      onTap: () {
                        Navigator.pushNamed(context, '/favorites');
                      },
                    ),

                    _ProfileMenuTile(
                      icon: Icons.info_outline,
                      title: AppStrings.t(context, 'profile_terms'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TermsPage()),
                        );
                      },
                    ),

                    // ---------- Language ----------
                    _ProfileMenuTile(
                      icon: Icons.language,
                      title: AppStrings.t(context, 'profile_language'),
                      subtitle: lang.isArabic ? 'العربية' : 'English',
                      onTap: () {
                        final languageProvider = context
                            .read<LanguageProvider>();

                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.language),
                                    title: const Text('English'),
                                    trailing: !languageProvider.isArabic
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : null,
                                    onTap: () {
                                      languageProvider.setLocale(
                                        const Locale('en'),
                                      );
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.language),
                                    title: const Text('العربية'),
                                    trailing: languageProvider.isArabic
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : null,
                                    onTap: () {
                                      languageProvider.setLocale(
                                        const Locale('ar'),
                                      );
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),

                    // ---------- Logout ----------
                    _ProfileMenuTile(
                      icon: Icons.logout,
                      title: AppStrings.t(context, 'profile_logout'),
                      isDestructive: true,
                      onTap: () => _showLogoutDialog(context, auth),
                    ),

                    if (phone.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        '${AppStrings.t(context, 'profile_mobile_label')}: $phone',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(
                            0.7,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ProfileStatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _ProfileStatChip({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final baseColor = color ?? colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: theme.brightness == Brightness.dark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: baseColor.withOpacity(0.15),
            child: Icon(icon, size: 18, color: baseColor),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final iconColor = isDestructive ? Colors.redAccent : colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: theme.brightness == Brightness.dark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: iconColor.withOpacity(0.12),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: isDestructive ? Colors.redAccent : null,
          ),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4, left: 4),
        child: Text(
          text,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleSmall?.color?.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
