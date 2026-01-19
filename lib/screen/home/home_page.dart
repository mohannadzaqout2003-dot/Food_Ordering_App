import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/localization/app_string.dart';
import 'package:restaurant_app/provider/cart_provider.dart';
import 'package:restaurant_app/provider/category_product.dart';
import 'package:restaurant_app/provider/notification_provider.dart';
import 'package:restaurant_app/provider/search_product.dart';
import 'package:restaurant_app/screen/cart/cart_page.dart';
import 'package:restaurant_app/screen/home/notification_page.dart';
import 'package:restaurant_app/screen/home/product_details_page.dart';
import 'package:restaurant_app/screen/orders/order_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CategoryProduct>().loadProducts());
  }

  @override
  Widget build(BuildContext context) {
    final cat = context.watch<CategoryProduct>();
    final search = context.watch<SearchProduct>();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final baseProducts = cat.productsByCategory;
    final products = search.isSearching
        ? baseProducts
              .where(
                (p) =>
                    p.name.toLowerCase().contains(search.query.toLowerCase()),
              )
              .toList()
        : baseProducts;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Icon(Icons.location_on, color: colorScheme.primary),
            SizedBox(width: 4.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.t(context, 'home_location'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  AppStrings.t(context, 'home_place_name'),
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ],
        ),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notif, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationPage(),
                        ),
                      );
                      notif.markAllRead();
                    },
                  ),
                  if (notif.unreadCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${notif.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // زر الطلبات
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrdersPage()),
              );
            },
            icon: const Icon(Icons.receipt_long),
          ),

          // السلة
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartPage()),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                  ),
                  if (cart.totalItems > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cart.totalItems}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------- Search ----------
              Container(
                width: double.infinity,
                height: 46.h,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: isDark
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: TextField(
                  onChanged: (value) {
                    context.read<SearchProduct>().updateQuery(value);
                  },
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: AppStrings.t(context, 'home_search_hint'),
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 10.h,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 14.h),

              /// ---------- Promo Card ----------
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withOpacity(0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22.r),
                  boxShadow: isDark
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.t(context, 'home_discount_title'),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AppStrings.t(context, 'home_discount_subtitle'),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimary.withOpacity(0.9),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 6.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.22),
                              ),
                            ),
                            child: Text(
                              AppStrings.t(context, 'home_shop_now'),
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(
                      Icons.local_grocery_store_rounded,
                      size: 40,
                      color: colorScheme.onPrimary,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 18.h),

              /// ---------- Categories chips ----------
              SizedBox(
                height: 36.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: cat.categories.length,
                  separatorBuilder: (_, _) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    final isSelected = cat.currentCategory == index;
                    return ChoiceChip(
                      label: Text(cat.categories[index]),
                      selected: isSelected,
                      backgroundColor: theme.cardColor.withOpacity(
                        isDark ? 0.9 : 1,
                      ),
                      selectedColor: colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : theme.textTheme.bodyMedium?.color,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      onSelected: (_) {
                        cat.changeCategory(index);
                        context.read<SearchProduct>().updateQuery('');
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: 16.h),

              /// ---------- Products Grid (Fully Responsive) ----------
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;

                    // Better responsive columns
                    final int crossAxisCount = w >= 1100
                        ? 5
                        : w >= 900
                        ? 4
                        : w >= 700
                        ? 3
                        : 2;

                    //  Responsive spacing
                    final double spacing = w >= 700 ? 14 : 12;

                    if (cat.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (products.isEmpty) {
                      return Center(
                        child: Text(AppStrings.t(context, 'home_no_products')),
                      );
                    }

                    return MasonryGridView.count(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 12.h),
                      itemCount: products.length,

                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: spacing,
                      crossAxisSpacing: spacing,

                      itemBuilder: (context, index) {
                        final product = products[index];
                        final realIndex = cat.products.indexOf(product);

                        return _ProductCardPro(
                          product: product,
                          isDark: isDark,
                          onOpen: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailsPage(product: product),
                              ),
                            );
                          },
                          onToggleFav: () {
                            final idx = realIndex == -1 ? index : realIndex;
                            cat.toggleFavorite(idx);
                          },
                          onAddToCart: () {
                            context.read<CartProvider>().addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product.name} ${AppStrings.t(context, 'home_added_to_cart')}',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCardPro extends StatelessWidget {
  final dynamic product; // Product type عندك
  final bool isDark;
  final VoidCallback onOpen;
  final VoidCallback onToggleFav;
  final VoidCallback onAddToCart;

  const _ProductCardPro({
    required this.product,
    required this.isDark,
    required this.onOpen,
    required this.onToggleFav,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: onOpen,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.black.withOpacity(0.06),
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //  Image with fixed ratio (keeps consistent look)
            AspectRatio(
              aspectRatio: 1.45,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                    child: Hero(
                      tag: "product_${product.favoriteKey}",
                      child: Image.network(
                        product.image,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.r),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.22),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: onToggleFav,
                      child: Container(
                        padding: EdgeInsets.all(7.w),
                        decoration: BoxDecoration(
                          color: theme.cardColor.withOpacity(0.88),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black.withOpacity(0.06),
                          ),
                        ),
                        child: Icon(
                          product.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: product.isFavorite
                              ? cs.error
                              : theme.iconTheme.color?.withOpacity(0.7),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.cardColor.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.06),
                        ),
                      ),
                      child: Text(
                        '\$${product.price}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //  Details auto-height
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      SizedBox(
                        width: 38.w,
                        height: 38.w,
                        child: IconButton(
                          onPressed: onAddToCart,
                          style: IconButton.styleFrom(
                            backgroundColor: cs.primary.withOpacity(0.12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          icon: Icon(
                            Icons.add_shopping_cart_rounded,
                            color: cs.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 16, color: cs.secondary),
                      SizedBox(width: 4.w),
                      Text(
                        '4.8',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: cs.primary.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          product.category.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.primary,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // keep Wrap (now safe because card can grow)
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: const [
                      // لو بدك dynamic خليه زي ما كان عندك
                    ],
                  ),

                  LayoutBuilder(
                    builder: (context, c) {
                      final show3 = c.maxWidth > 170;
                      final show2 = c.maxWidth > 140;
                      return Wrap(
                        spacing: 6.w,
                        runSpacing: 6.h,
                        children: [
                          _SmallTagChip(
                            label: '450 kcal',
                            icon: Icons.local_fire_department_outlined,
                          ),
                          if (show2)
                            _SmallTagChip(
                              label: '20 min',
                              icon: Icons.timer_outlined,
                            ),
                          if (show3)
                            _SmallTagChip(
                              label: 'Nearby',
                              icon: Icons.near_me_outlined,
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallTagChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SmallTagChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: cs.surface.withOpacity(0.70),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: cs.primary),
          SizedBox(width: 5.w),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
