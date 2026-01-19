import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/localization/app_string.dart';
import 'package:restaurant_app/model/product_model.dart';
import 'package:restaurant_app/provider/cart_provider.dart';
import 'package:restaurant_app/provider/category_product.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cat = context.watch<CategoryProduct>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final List<Product> favorites = cat.products
        .where((p) => p.isFavorite)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.t(context, 'favorites_title')),
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.t(context, 'favorites_empty_title'),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.t(context, 'favorites_empty_subtitle'),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Search bar (UI فقط - لو بدك فلترة فعلية خبرني)
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 6.h),
                  child: Container(
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: isDark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        hintText: AppStrings.t(
                          context,
                          'favorites_search_hint',
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;

                      final int crossAxisCount = w >= 1100
                          ? 5
                          : w >= 900
                          ? 4
                          : w >= 700
                          ? 3
                          : 2;

                      final double spacing = w >= 700 ? 14 : 12;

                      return MasonryGridView.count(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.all(16.w),
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: spacing,
                        crossAxisSpacing: spacing,
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          final product = favorites[index];
                          final realIndex = cat.products.indexOf(product);

                          return _FavoriteCardPro(
                            product: product,
                            isDark: isDark,
                            onRemoveFav: () {
                              if (realIndex != -1) {
                                cat.toggleFavorite(realIndex);
                              }
                            },
                            onAddToCart: () {
                              context.read<CartProvider>().addToCart(product);
                              final messenger = ScaffoldMessenger.of(context);
                              messenger.clearSnackBars();
                              messenger.showSnackBar(
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
    );
  }
}

class _FavoriteCardPro extends StatelessWidget {
  final Product product;
  final bool isDark;
  final VoidCallback onRemoveFav;
  final VoidCallback onAddToCart;

  const _FavoriteCardPro({
    required this.product,
    required this.isDark,
    required this.onRemoveFav,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ image auto (no fixed height) + keeps premium ratio
          AspectRatio(
            aspectRatio: 1.35,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  child: Image.network(
                    product.image,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // gradient overlay
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
                          Colors.black.withOpacity(0.20),
                        ],
                      ),
                    ),
                  ),
                ),

                // remove favorite
                Positioned(
                  top: 10,
                  right: 10,
                  child: InkWell(
                    onTap: onRemoveFav,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: EdgeInsets.all(7.w),
                      decoration: BoxDecoration(
                        color: theme.cardColor.withOpacity(0.90),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.06),
                        ),
                      ),
                      child: Icon(
                        Icons.favorite_rounded,
                        color: cs.error,
                        size: 18,
                      ),
                    ),
                  ),
                ),

                // price pill
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
                      border: Border.all(color: Colors.black.withOpacity(0.06)),
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

          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 6.h),

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
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                SizedBox(
                  width: double.infinity,
                  height: 40.h,
                  child: OutlinedButton.icon(
                    onPressed: onAddToCart,
                    icon: Icon(
                      Icons.add_shopping_cart_rounded,
                      size: 18,
                      color: cs.primary,
                    ),
                    label: Text(
                      AppStrings.t(context, 'favorites_add_to_cart'),
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.primary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: cs.primary.withOpacity(0.6)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
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
