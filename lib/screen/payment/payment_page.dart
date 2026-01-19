import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/localization/app_string.dart';
import 'package:restaurant_app/provider/auth_provider.dart';
import 'package:restaurant_app/provider/cart_provider.dart';
import 'package:restaurant_app/provider/order_provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedMethod = 'cash_on_delivery';

  void _toast(BuildContext context, String text) {
    final m = ScaffoldMessenger.of(context);
    m.clearSnackBars();
    m.showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final methodLabel = _selectedMethod == 'cash_on_delivery'
        ? AppStrings.t(context, 'payment_cash_on_delivery')
        : AppStrings.t(context, 'payment_card_simulation');

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient (premium soft)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cs.primary.withOpacity(isDark ? 0.22 : 0.16),
                    cs.background,
                    cs.background,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Custom header
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 6.h),
                  child: Row(
                    children: [
                      _CircleIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          AppStrings.t(context, 'payment_title'),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 110.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section title
                        Text(
                          AppStrings.t(context, 'payment_select_method'),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // Payment methods (selectable cards)
                        Row(
                          children: [
                            Expanded(
                              child: _MethodCard(
                                selected: _selectedMethod == 'cash_on_delivery',
                                title: AppStrings.t(
                                  context,
                                  'payment_cash_on_delivery',
                                ),
                                subtitle: AppStrings.t(
                                  context,
                                  'cart_login_required',
                                ),
                                icon: Icons.local_shipping_outlined,
                                badgeText: AppStrings.t(
                                  context,
                                  'payment_method_label',
                                ),
                                onTap: () => setState(() {
                                  _selectedMethod = 'cash_on_delivery';
                                }),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _MethodCard(
                                selected: _selectedMethod == 'card_simulation',
                                title: AppStrings.t(
                                  context,
                                  'payment_card_simulation',
                                ),
                                subtitle: '(Test mode – no real payment)',
                                icon: Icons.credit_card_rounded,
                                badgeText: 'Test',
                                onTap: () => setState(() {
                                  _selectedMethod = 'card_simulation';
                                }),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 18.h),

                        // Summary
                        Text(
                          AppStrings.t(context, 'payment_summary'),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        _GlassCard(
                          child: Column(
                            children: [
                              _SummaryRow(
                                left: AppStrings.t(context, 'cart_subtotal'),
                                right:
                                    '\$${cart.totalPrice.toStringAsFixed(2)}',
                                rightStyle: theme.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                              SizedBox(height: 10.h),
                              _SummaryRow(
                                left: AppStrings.t(
                                  context,
                                  'orders_items_label',
                                ),
                                right: '${cart.totalItems}',
                              ),
                              SizedBox(height: 10.h),
                              _SummaryRow(
                                left: AppStrings.t(
                                  context,
                                  'payment_method_label',
                                ),
                                right: methodLabel,
                                rightStyle: theme.textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: cs.primary,
                                    ),
                              ),
                              SizedBox(height: 12.h),
                              Divider(
                                height: 1,
                                color: theme.dividerColor.withOpacity(0.6),
                              ),
                              SizedBox(height: 12.h),

                              // Total highlight
                              _TotalPill(
                                title: AppStrings.t(
                                  context,
                                  'order_details_total',
                                ),
                                value:
                                    '\$${cart.totalPrice.toStringAsFixed(2)}',
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
          ),

          // Bottom action bar (sticky)
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor.withOpacity(
                    isDark ? 0.75 : 0.90,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 18,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.t(context, 'order_details_total'),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.textTheme.bodySmall?.color
                                      ?.withOpacity(0.7),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '\$${cart.totalPrice.toStringAsFixed(2)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        SizedBox(
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: () async {
                              final auth = context.read<AuthProvider>();

                              if (cart.items.isEmpty) {
                                _toast(
                                  context,
                                  AppStrings.t(context, 'cart_empty_error'),
                                );
                                return;
                              }

                              if (auth.user == null) {
                                _toast(
                                  context,
                                  AppStrings.t(context, 'cart_login_required'),
                                );
                                return;
                              }

                              final methodForOrder =
                                  _selectedMethod == 'cash_on_delivery'
                                  ? 'Cash on Delivery'
                                  : 'Card (Simulation)';

                              final statusForOrder =
                                  _selectedMethod == 'cash_on_delivery'
                                  ? 'Pending (Cash on Delivery)'
                                  : 'Paid (Simulation)';

                              try {
                                await context.read<CartProvider>().checkout(
                                  userId: auth.user!.uid,
                                  paymentMethod: methodForOrder,
                                  paymentStatus: statusForOrder,
                                );

                                await context
                                    .read<OrdersProvider>()
                                    .loadOrders();

                                if (!context.mounted) return;

                                _toast(
                                  context,
                                  AppStrings.t(context, 'cart_order_success'),
                                );

                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/main',
                                  (route) => false,
                                );
                              } catch (e) {
                                _toast(context, 'Error: $e');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: cs.onPrimary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 12.h,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline_rounded),
                                SizedBox(width: 8.w),
                                Text(
                                  AppStrings.t(context, 'payment_place_order'),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final bool selected;
  final String title;
  final String subtitle;
  final IconData icon;
  final String badgeText;
  final VoidCallback onTap;

  const _MethodCard({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.badgeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final double iconBox = 42.w.clamp(36.0, 46.0);
    final double pad = 14.w.clamp(12.0, 16.0);

    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(pad),
        decoration: BoxDecoration(
          color: selected ? cs.primary.withOpacity(0.10) : theme.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected
                ? cs.primary.withOpacity(0.55)
                : Colors.black.withOpacity(0.06),
            width: selected ? 1.2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: iconBox,
                  height: iconBox,
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(icon, color: cs.primary, size: 20.sp),
                ),
                SizedBox(width: 10.w),
                const Spacer(),

                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 72.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? cs.primary
                          : cs.surface.withOpacity(0.70),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: selected
                            ? Colors.transparent
                            : Colors.black.withOpacity(0.05),
                      ),
                    ),
                    child: Text(
                      badgeText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: selected
                            ? cs.onPrimary
                            : theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),

            SizedBox(height: 6.h),

            // ✅ Subtitle safe
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.75),
                height: 1.35,
              ),
            ),

            SizedBox(height: 12.h),

            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8.w,
              runSpacing: 6.h,
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: 18,
                  color: selected
                      ? cs.primary
                      : theme.iconTheme.color?.withOpacity(0.6),
                ),
                Text(
                  selected
                      ? AppStrings.t(context, 'payment_selected')
                      : AppStrings.t(context, 'payment_select'),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: selected
                        ? cs.primary
                        : theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.white.withOpacity(0.72),
            borderRadius: BorderRadius.circular(20.r),
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

class _SummaryRow extends StatelessWidget {
  final String left;
  final String right;
  final TextStyle? rightStyle;

  const _SummaryRow({required this.left, required this.right, this.rightStyle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          right,
          style:
              rightStyle ??
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _TotalPill extends StatelessWidget {
  final String title;
  final String value;

  const _TotalPill({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.primary.withOpacity(0.22)),
      ),
      child: Row(
        children: [
          Icon(Icons.receipt_long, size: 18, color: cs.primary),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

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
          color: theme.cardColor.withOpacity(0.92),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}
