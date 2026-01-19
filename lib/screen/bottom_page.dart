import 'package:cool_nav/cool_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/nav_provider.dart';
import 'home/home_page.dart';
import 'orders/order_page.dart';
import 'profile/profile_page.dart';

class BottomPage extends StatelessWidget {
  const BottomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final pages = const [HomePage(), OrdersPage(), ProfilePage()];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: IndexedStack(index: nav.index, children: pages),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.5 : 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 10),
          child: FlipBoxNavigationBar(
            currentIndex: nav.index,
            onTap: (i) => nav.updateIndex(i),
            verticalPadding: 16.0,

            items: [
              FlipBoxNavigationBarItem(
                name: 'Home',
                selectedIcon: Icons.home,
                unselectedIcon: Icons.home_outlined,
                selectedBackgroundColor: colorScheme.primary,
                unselectedBackgroundColor: colorScheme.primary.withOpacity(
                  0.25,
                ),
              ),
              FlipBoxNavigationBarItem(
                name: 'Orders',
                selectedIcon: Icons.receipt_long,
                unselectedIcon: Icons.receipt_long_outlined,
                selectedBackgroundColor: colorScheme.secondary,
                unselectedBackgroundColor: colorScheme.secondary.withOpacity(
                  0.25,
                ),
              ),
              FlipBoxNavigationBarItem(
                name: 'Profile',
                selectedIcon: Icons.person,
                unselectedIcon: Icons.person_outline,
                selectedBackgroundColor: colorScheme.tertiary,
                unselectedBackgroundColor: colorScheme.tertiary.withOpacity(
                  0.25,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
