import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:restaurant_app/localization/app_string.dart';
import 'package:restaurant_app/provider/auth_provider.dart';
import 'package:restaurant_app/provider/cart_provider.dart';
import 'package:restaurant_app/provider/category_product.dart';
import 'package:restaurant_app/provider/language_provider.dart';
import 'package:restaurant_app/provider/nav_provider.dart';
import 'package:restaurant_app/provider/notification_provider.dart';
import 'package:restaurant_app/provider/order_provider.dart';
import 'package:restaurant_app/provider/search_product.dart';
import 'package:restaurant_app/provider/theme_provider.dart';

import 'package:restaurant_app/screen/bottom_page.dart';
import 'package:restaurant_app/screen/favorites/favorit_page.dart';
import 'package:restaurant_app/screen/login/login_page.dart';
import 'package:restaurant_app/screen/orders/order_page.dart';
import 'package:restaurant_app/screen/profile/term_page.dart';
import 'package:restaurant_app/screen/splash_screen.dart';
import 'package:restaurant_app/theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProduct()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SearchProduct()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => NavProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = context.watch<LanguageProvider>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.t(context, 'app_title'),

          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,

          locale: languageProvider.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          initialRoute: '/splash',
          routes: {
            '/splash': (_) => const SplashPage(),
            '/': (_) => Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    if (auth.user != null) {
                      return const BottomPage();
                    } else {
                      return const LoginPage();
                    }
                  },
                ),
            '/login': (_) => const LoginPage(),
            '/main': (_) => const BottomPage(),
            '/orders': (_) => const OrdersPage(),
            '/favorites': (_) => const FavoritesPage(),
            '/terms': (_) => const TermsPage(),
          },
        );
      },
    );
  }
}
