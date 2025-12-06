import 'package:flutter/material.dart';

class AppResponsive {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static bool isMobile(BuildContext context) => width(context) < 600;

  static bool isTablet(BuildContext context) =>
      width(context) >= 600 && width(context) < 1024;

  static bool isDesktop(BuildContext context) => width(context) >= 1024;

  static double maxBodyWidth(BuildContext context) {
    final w = width(context);
    if (w >= 1200) return 1000;
    if (w >= 900) return 900;
    return w;
  }
}
