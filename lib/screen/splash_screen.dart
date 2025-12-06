import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/localization/app_string.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.90,
      upperBound: 1.05,
    )..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          /// Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFff6a00), Color(0xFFee0979)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Icon Animation
                ScaleTransition(
                  scale: _controller,
                  child: Container(
                    width: 110.w,
                    height: 110.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.9),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.fastfood_rounded,
                      color: Colors.white,
                      size: 50.sp,
                    ),
                  ),
                ),

                SizedBox(height: 22.h),

                /// Title
                Text(
                  AppStrings.t(context, 'splash_title'),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10.h),

                /// Subtitle
                Text(
                  AppStrings.t(context, 'splash_subtitle'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    height: 1.3,
                  ),
                ),

                SizedBox(height: 30.h),

                /// Loader
                SizedBox(
                  width: 26.w,
                  height: 26.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
