import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/localization/app_string.dart';
import 'package:restaurant_app/model/product_model.dart';
import 'package:restaurant_app/provider/cart_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _quantity = 1;

  void _changeQty(int delta) {
    setState(() => _quantity = (_quantity + delta).clamp(1, 20));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final product = widget.product;

    final total = (product.price * _quantity).toStringAsFixed(2);

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 320.h,
            backgroundColor: cs.surface.withOpacity(0.88),
            elevation: 0,
            centerTitle: true,
            leading: _CircleIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: _CircleIconButton(
                  icon: Icons.favorite_border_rounded,
                  onTap: () {},
                ),
              ),
            ],
            title: LayoutBuilder(
              builder: (context, constraints) {
                final current = constraints.biggest.height;
                final minH =
                    kToolbarHeight + MediaQuery.of(context).padding.top;
                final maxH = 320.h;

                final t = ((maxH - current) / (maxH - minH)).clamp(0.0, 1.0);

                return Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: Offset(0, (1 - t) * 6),
                    child: Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                );
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 90.h, 16.w, 12.h),
                child: Hero(
                  tag: "product_${product.favoriteKey}",
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28.r),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(product.image, fit: BoxFit.cover),

                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 120.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.30),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.all(14.w),
                            child: _GlassBadge(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: 18,
                                    color: cs.secondary,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    '4.8',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Container(
                                    width: 1,
                                    height: 16,
                                    color: Colors.white.withOpacity(0.35),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    product.category.toUpperCase(),
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.3,
                                          color: Colors.white.withOpacity(0.92),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 110.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      _PricePill(price: product.price.toStringAsFixed(2)),
                    ],
                  ),

                  SizedBox(height: 14.h),

                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: const [
                      _InfoChipPro(
                        icon: Icons.timer_outlined,
                        label: 'Prep',
                        value: '20 min',
                      ),
                      _InfoChipPro(
                        icon: Icons.local_fire_department_outlined,
                        label: 'Energy',
                        value: '450 kcal',
                      ),
                      _InfoChipPro(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Size',
                        value: '1 KG',
                      ),
                    ],
                  ),

                  SizedBox(height: 22.h),

                  Text(
                    AppStrings.t(context, 'order_details_items'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    product.description.isNotEmpty
                        ? product.description
                        : AppStrings.t(
                            context,
                            'product_details_placeholder',
                          ).replaceAll('{name}', product.name),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.65,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.82,
                      ),
                    ),
                  ),

                  SizedBox(height: 26.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.t(context, 'product_details_quantity'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      _QtySelectorAnimated(
                        quantity: _quantity,
                        onMinus: () => _changeQty(-1),
                        onPlus: () => _changeQty(1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(child: _TotalBlock(total: total)),
              SizedBox(width: 12.w),
              SizedBox(
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    final cart = context.read<CartProvider>();
                    for (int i = 0; i < _quantity; i++) {
                      cart.addToCart(product);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${product.name} ${AppStrings.t(context, 'home_added_to_cart')}',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_shopping_cart_rounded, size: 20),
                      SizedBox(width: 8.w),
                      Text(
                        AppStrings.t(context, 'favorites_add_to_cart'),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
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

// -------------------- GLASS WIDGET --------------------
class _GlassBadge extends StatelessWidget {
  final Widget child;
  const _GlassBadge({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.14),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: child,
        ),
      ),
    );
  }
}

// -------------------- SMALL COMPONENTS --------------------
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8.w),
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          color: theme.cardColor.withOpacity(0.88),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _PricePill extends StatelessWidget {
  final String price;
  const _PricePill({required this.price});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.primary.withOpacity(0.18)),
      ),
      child: Text(
        '\$$price',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w900,
          color: cs.primary,
        ),
      ),
    );
  }
}

class _InfoChipPro extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChipPro({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: cs.surface.withOpacity(0.75),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: cs.primary),
          SizedBox(width: 8.w),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.75),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            ' · ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.55),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _QtySelectorAnimated extends StatelessWidget {
  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _QtySelectorAnimated({
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyButton(icon: Icons.remove_rounded, onTap: onMinus),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, anim) {
                final slide = Tween<Offset>(
                  begin: const Offset(0, 0.25),
                  end: Offset.zero,
                ).animate(anim);
                return FadeTransition(
                  opacity: anim,
                  child: SlideTransition(position: slide, child: child),
                );
              },
              child: Text(
                '$quantity',
                key: ValueKey(quantity),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          _QtyButton(icon: Icons.add_rounded, onTap: onPlus),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(0.10),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(icon, size: 18, color: cs.primary),
      ),
    );
  }
}

class _TotalBlock extends StatelessWidget {
  final String total;
  const _TotalBlock({required this.total});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      height: 70  .h,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: cs.surface.withOpacity(0.75),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.t(context, 'order_details_total'),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.65),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            '\$$total',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
