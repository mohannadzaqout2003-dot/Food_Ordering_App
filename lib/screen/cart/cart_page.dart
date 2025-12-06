import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/localization/app_string.dart';
import 'package:restaurant_app/model/cart_item.dart';
import 'package:restaurant_app/provider/auth_provider.dart';
import 'package:restaurant_app/provider/cart_provider.dart';
import 'package:restaurant_app/screen/payment/payment_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.t(context, 'cart_title'),
          style: TextStyle(fontSize: 16.sp),
        ),
        centerTitle: true,
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                AppStrings.t(context, 'cart_empty'),
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final CartItem item = items[index];

                      return Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                isDark ? 0.20 : 0.06,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                item.product.image,
                                width: 70.w,
                                height: 70.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '\$${item.product.price}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 11.sp,
                                      color: colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => cart.decreaseQty(item),
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: colorScheme.primary,
                                        size: 22.sp,
                                      ),
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(fontSize: 14.sp),
                                    ),
                                    IconButton(
                                      onPressed: () => cart.increaseQty(item),
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: colorScheme.primary,
                                        size: 22.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '\$${item.totalPrice.toStringAsFixed(2)}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                /// ----- Summary + Checkout -----
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.t(context, 'cart_subtotal'),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '\$${cart.totalPrice.toStringAsFixed(2)}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                          ),
                          onPressed: () {
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
                                    AppStrings.t(
                                      context,
                                      'cart_login_required',
                                    ),
                                  ),
                                ),
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PaymentPage(),
                              ),
                            );
                          },

                          child: Text(
                            AppStrings.t(context, 'cart_checkout'),
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
              ],
            ),
    );
  }
}
