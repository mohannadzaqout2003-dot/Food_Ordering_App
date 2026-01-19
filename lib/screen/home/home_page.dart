import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                          Text(
                            AppStrings.t(context, 'home_shop_now'),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
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
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
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
                    int crossAxisCount;
                    if (constraints.maxWidth >= 1024) {
                      crossAxisCount = 5; // Web / Desktop
                    } else if (constraints.maxWidth >= 800) {
                      crossAxisCount = 4; // Large Tablet
                    } else if (constraints.maxWidth >= 600) {
                      crossAxisCount = 3; // Small Tablet
                    } else {
                      crossAxisCount = 2; // Phones
                    }

                    final double childAspectRatio = constraints.maxWidth < 400
                        ? 0.5
                        : 0.60;

                    if (cat.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (products.isEmpty) {
                      return Center(
                        child: Text(AppStrings.t(context, 'home_no_products')),
                      );
                    }

                    const String prepTime = '20 min';
                    const String calories = '450 kcal';
                    const String rating = '4.8';

                    return GridView.builder(
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final realIndex = cat.products.indexOf(product);

                        final addedToCartText = AppStrings.t(
                          context,
                          'home_added_to_cart',
                        );

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailsPage(product: product),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: isDark
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// ---------- Image + Favorite ----------
                                SizedBox(
                                  height: 110.h,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.r),
                                          topRight: Radius.circular(20.r),
                                        ),
                                        child: Hero(
                                          tag: "product_${product.favoriteKey}",
                                          child: Image.network(
                                            product.image,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: InkWell(
                                          onTap: () {
                                            final idx = realIndex == -1
                                                ? index
                                                : realIndex;
                                            cat.toggleFavorite(idx);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: theme.cardColor
                                                  .withOpacity(0.95),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              product.isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: product.isFavorite
                                                  ? colorScheme.error
                                                  : Colors.grey.shade500,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 8.h,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                product.name,
                                                style: theme
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(width: 6),
                                            IconButton.filled(
                                              style: IconButton.styleFrom(
                                                backgroundColor: colorScheme
                                                    .primary
                                                    .withOpacity(0.14),
                                              ),
                                              onPressed: () {
                                                context
                                                    .read<CartProvider>()
                                                    .addToCart(product);
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      '${product.name} $addedToCartText',
                                                    ),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.add_shopping_cart_rounded,
                                                color: colorScheme.primary,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 4.h),

                                        Row(
                                          children: [
                                            Text(
                                              '\$${product.price}',
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            const Spacer(),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  size: 14,
                                                  color: Colors.amber,
                                                ),
                                                SizedBox(width: 3.w),
                                                Text(
                                                  rating,
                                                  style:
                                                      theme.textTheme.bodySmall,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 6.h),

                                        /// Chips
                                        Wrap(
                                          spacing: 4.w,
                                          runSpacing: 4.h,
                                          children: [
                                            _SmallTagChip(
                                              label: product.category
                                                  .toUpperCase(),
                                              icon: Icons.category_outlined,
                                            ),
                                            _SmallTagChip(
                                              label: calories,
                                              icon: Icons
                                                  .local_fire_department_outlined,
                                            ),
                                            _SmallTagChip(
                                              label: prepTime,
                                              icon: Icons.timer_outlined,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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

class _SmallTagChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SmallTagChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.35),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: colorScheme.primary),
          const SizedBox(width: 3),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
