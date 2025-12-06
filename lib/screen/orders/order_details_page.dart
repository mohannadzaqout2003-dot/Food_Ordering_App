import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/localization/app_string.dart';
import 'package:restaurant_app/model/order_model.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsPage({super.key, required this.order});

  String _formatDate(BuildContext context, DateTime? date) {
    if (date == null) {
      return AppStrings.t(context, 'orders_unknown_date');
    }
    final d = date.toLocal();
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year.toString();
    final hour = d.hour.toString().padLeft(2, '0');
    final minute = d.minute.toString().padLeft(2, '0');
    return '$day/$month/$year  $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final dateText = _formatDate(context, order.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order #${order.id.substring(0, 6)}',
          style: TextStyle(fontSize: 16.sp),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.t(context, 'order_details_summary'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '${AppStrings.t(context, 'order_details_date')} $dateText',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              '${AppStrings.t(context, 'order_details_total')} \$${order.totalPrice.toStringAsFixed(2)}',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              AppStrings.t(context, 'order_details_items'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: ListView.separated(
                itemCount: order.items.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  final itemTotal = item.price * item.quantity;

                  return Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: isDark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            item.image,
                            width: 60.w,
                            height: 60.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Qty: ${item.quantity}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.textTheme.bodySmall?.color
                                      ?.withOpacity(0.7),
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withOpacity(0.9),
                                fontSize: 11.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '\$${itemTotal.toStringAsFixed(2)}',
                              style: theme.textTheme.bodySmall?.copyWith(
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
          ],
        ),
      ),
    );
  }
}
