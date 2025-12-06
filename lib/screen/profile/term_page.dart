import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/localization/app_string.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.t(context, 'terms_title')),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _TermsIntroBox(text: AppStrings.t(context, 'terms_intro')),

              SizedBox(height: 18.h),

              _TermsItem(
                icon: Icons.person_outline,
                title: AppStrings.t(context, 'terms_section_account_title'),
                body: AppStrings.t(context, 'terms_section_account_body'),
              ),

              SizedBox(height: 14.h),

              _TermsItem(
                icon: Icons.shopping_basket_outlined,
                title: AppStrings.t(context, 'terms_section_orders_title'),
                body: AppStrings.t(context, 'terms_section_orders_body'),
              ),

              SizedBox(height: 14.h),

              _TermsItem(
                icon: Icons.privacy_tip_outlined,
                title: AppStrings.t(context, 'terms_section_data_title'),
                body: AppStrings.t(context, 'terms_section_data_body'),
              ),

              SizedBox(height: 14.h),

              _TermsItem(
                icon: Icons.support_agent_outlined,
                title: AppStrings.t(context, 'terms_section_contact_title'),
                body: AppStrings.t(context, 'terms_section_contact_body'),
              ),

              SizedBox(height: 20.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: color.primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text(
                  "Last update: 2025",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsIntroBox extends StatelessWidget {
  final String text;

  const _TermsIntroBox({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: color.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          height: 1.5,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}

class _TermsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _TermsItem({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Row: Icon + Title
          Row(
            children: [
              Icon(icon, size: 20, color: color.primary),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          /// Body text
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              fontSize: 13.5.sp,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
