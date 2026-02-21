

import 'package:flutter/material.dart';

import '../../utils/app_colors/app_colors.dart';


class CategoryItem extends StatelessWidget {
  final String title;
  final String image;
  final bool selected;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.title,
    required this.image,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 85,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.primaryGradient : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),

          /// 👇 primary border visible
          border: Border.all(
            color: selected
                ? Colors.transparent
                : AppColors.primary.withValues(alpha: 0.4),
            width: 1.2,
          ),

          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: const Offset(0, 3),
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// IMAGE BOX
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: image.isNotEmpty
                    ? Image.network(
                  image,
                  fit: BoxFit.cover,
                )
                    : Icon(
                  Icons.category,
                  color: selected
                      ? Colors.white
                      : AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 6),

            /// TITLE
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white
                    : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}