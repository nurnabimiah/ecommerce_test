import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../utils/app_colors/app_colors.dart';

const double _kCategoryItemWidth = 90;
const double _kCategorySectionHeight = 90;

/// Shimmer placeholder for the horizontal categories list.
/// Matches the category item layout: 90x90 card with icon + text.
class CategoriesShimmer extends StatelessWidget {
  const CategoriesShimmer({super.key});

  static const int _itemCount = 5;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kCategorySectionHeight,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: _itemCount,
          itemBuilder: (_, __) => const _ShimmerItem(),
        ),
      ),
    );
  }
}

class _ShimmerItem extends StatelessWidget {
  const _ShimmerItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kCategoryItemWidth,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 12,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
