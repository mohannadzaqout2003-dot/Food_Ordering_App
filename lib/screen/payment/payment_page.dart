import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/localization/app_string.dart';
import 'package:restaurant_app/provider/auth_provider.dart';
import 'package:restaurant_app/provider/cart_provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedMethod = 'cash_on_delivery';

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.t(context, 'payment_title')),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.t(context, 'payment_select_method'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: 'cash_on_delivery',
                    groupValue: _selectedMethod,
                    title: Text(
                      AppStrings.t(context, 'payment_cash_on_delivery'),
                    ),
                    subtitle: Text(
                      AppStrings.t(context, 'cart_login_required'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color
                            ?.withOpacity(0.7),
                      ),
                    ),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _selectedMethod = value);
                    },
                  ),
                  const Divider(height: 0),
                  RadioListTile<String>(
                    value: 'card_simulation',
                    groupValue: _selectedMethod,
                    title: Text(
                      AppStrings.t(context, 'payment_card_simulation'),
                    ),
                    subtitle: Text(
                      '(Test mode – no real payment)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color
                            ?.withOpacity(0.7),
                      ),
                    ),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _selectedMethod = value);
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            Text(
              AppStrings.t(context, 'payment_summary'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          AppStrings.t(context, 'cart_subtotal'),
                          style: theme.textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Text(
                          '\$${cart.totalPrice.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Text(
                          AppStrings.t(context, 'orders_items_label'),
                          style: theme.textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Text(
                          '${cart.totalItems}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Text(
                          AppStrings.t(context, 'payment_method_label'),
                          style: theme.textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Text(
                          _selectedMethod == 'cash_on_delivery'
                              ? AppStrings.t(
                                  context,
                                  'payment_cash_on_delivery',
                                )
                              : AppStrings.t(
                                  context,
                                  'payment_card_simulation',
                                ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final auth = context.read<AuthProvider>();

                  if (cart.items.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppStrings.t(context, 'cart_empty_error'),
                        ),
                      ),
                    );
                    return;
                  }

                  if (auth.user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppStrings.t(context, 'cart_login_required'),
                        ),
                      ),
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

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        AppStrings.t(context, 'cart_order_success'),
      ),
    ),
  );

  if (!mounted) return;

  Navigator.pushNamedAndRemoveUntil(
    context,
    '/main',
    (route) => false,
  );
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}

                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                child: Text(
                  AppStrings.t(context, 'payment_place_order'),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
