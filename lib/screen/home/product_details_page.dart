import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/localization/app_string.dart';
import 'package:restaurant_app/model/product_model.dart';
import 'package:restaurant_app/provider/cart_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _quantity = 1;

  void _changeQty(int delta) {
    setState(() {
      _quantity = (_quantity + delta).clamp(1, 20);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final product = widget.product;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        title: Text(
          product.name,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 8.h),

                  Hero(
                    tag: "product_${product.favoriteKey}",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.r),
                      child: AspectRatio(
                        aspectRatio: 1.5,
                        child: Image.network(product.image, fit: BoxFit.cover),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(26.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '\$${product.price}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Text(
                                product.category.toUpperCase(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 18,
                                  color: Colors.amber,
                                ),
                                SizedBox(width: 4.w),
                                Text('4.8', style: theme.textTheme.bodyMedium),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: [
                            _InfoChip(
                              icon: Icons.timer_outlined,
                              label: 'Prep',
                              value: '20 min',
                              iconColor: Colors.amber,
                            ),
                            _InfoChip(
                              icon: Icons.local_fire_department_outlined,
                              label: 'Energy',
                              value: '450 kcal',
                              iconColor: Colors.amber,
                            ),
                            _InfoChip(
                              icon: Icons.shopping_bag_outlined,
                              label: 'Size',
                              value: '1 KG',
                              iconColor: Colors.amber,
                            ),
                          ],
                        ),

                        SizedBox(height: 22.h),

                        Text(
                          AppStrings.t(context, 'order_details_items'),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        Text(
                          product.description.isNotEmpty
                              ? product.description
                              : AppStrings.t(
                                  context,
                                  'product_details_placeholder',
                                ).replaceAll('{name}', product.name),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.85),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        Text(
                          AppStrings.t(context, 'product_details_quantity'),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                color: theme.cardColor,
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _changeQty(-1),
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(
                                    '$_quantity',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: () => _changeQty(1),
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.t(context, 'order_details_total'),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '\$${(product.price * _quantity).toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        final cart = context.read<CartProvider>();
                        for (int i = 0; i < _quantity; i++) {
                          cart.addToCart(product);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${product.name} ${AppStrings.t(context, 'home_added_to_cart')}',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 28.w,
                          vertical: 10.h,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add_shopping_cart_rounded),
                          SizedBox(width: 6.w),
                          Text(
                            AppStrings.t(context, 'favorites_add_to_cart'),
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor ?? colorScheme.primary),
          SizedBox(width: 6.w),
          Text(
            '$label · ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
