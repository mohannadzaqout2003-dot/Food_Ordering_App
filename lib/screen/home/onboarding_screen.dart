import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:restaurant_app/localization/app_string.dart';
import 'package:restaurant_app/theme/app_theme.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: AppStrings.t(context, 'onboarding_slide_1_title'),
          body: AppStrings.t(context, 'onboarding_slide_1_description'),
          image: Center(child: Image.asset("assets/o1.jpg")),
          decoration: PageDecoration(
            imageFlex: 3,
            bodyFlex: 1,
            imagePadding: EdgeInsets.all(24),
            pageColor: Theme.of(context).brightness == Brightness.light
                ? AppColors.backgroundLight
                : AppColors.backgroundDark,
          ),
        ),
        PageViewModel(
          title: AppStrings.t(context, 'onboarding_slide_2_title'),
          body: AppStrings.t(context, 'onboarding_slide_2_description'),
          image: Center(child: Image.asset("assets/o2.jpg")),
          decoration: PageDecoration(
            imageFlex: 3,
            bodyFlex: 1,
            imagePadding: EdgeInsets.all(24),
            pageColor: Theme.of(context).brightness == Brightness.light
                ? AppColors.backgroundLight
                : AppColors.backgroundDark,
          ),
        ),
        PageViewModel(
          title: AppStrings.t(context, 'onboarding_slide_3_title'),
          body: AppStrings.t(context, 'onboarding_slide_3_description'),
          image: Center(child: Image.asset("assets/o3.jpg")),
          decoration: PageDecoration(
            imageFlex: 3,
            bodyFlex: 1,
            imagePadding: EdgeInsets.all(24),
            pageColor: Theme.of(context).brightness == Brightness.light
                ? AppColors.backgroundLight
                : AppColors.backgroundDark,
          ),
        ),
      ],
      onDone: () {
        Navigator.pushReplacementNamed(context, '/');
      },
      showSkipButton: true,
      skip: Text(
        AppStrings.t(context, 'onboarding_skip'),
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.primaryLight
              : AppColors.primaryDark,
        ),
      ),
      next: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.primaryLight
            : AppColors.primaryDark,
      ),
      done: Text(
        textAlign: TextAlign.center,
        AppStrings.t(context, 'onboarding_done'),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.primaryLight
              : AppColors.primaryDark,
          fontSize: 14.sp,
          letterSpacing: 1.5,
          fontFamily: 'CustomFont',
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),

      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        activeSize: Size(22.0, 10.0),
        activeColor: Theme.of(context).brightness == Brightness.light
            ? AppColors.primaryLight
            : AppColors.primaryDark,
        spacing: EdgeInsets.symmetric(horizontal: 3.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
