import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/category_card_widget.dart';
import '../../../../common/widgets/product_card_widgets.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../controller/product_controller.dart';
import '../widgets/categories_shimmer.dart';
import '../widgets/products_shimmer.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home_screen';
  HomeScreen({super.key});

  final controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text("Shop"),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.gradient,
          ),
        ),
        actions: [
          Obx(() => Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
              if (controller.cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text(
                      controller.cartCount.toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
            ],
          )),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          /// SEARCH
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          /// CATEGORIES
          SizedBox(
            height: 90,
            child: Obx(() {
              if (controller.isLoadingCategories.value) {
                return const CategoriesShimmer();
              }
              if (controller.categoriesError.value.isNotEmpty) {
                return _CategoryErrorSection(
                  message: controller.categoriesError.value,
                  onRetry: controller.retryCategories,
                );
              }
              if (controller.categories.isEmpty) {
                return const SizedBox.shrink();
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: controller.categories.length,
                itemBuilder: (_, i) {
                  final category = controller.categories[i];
                  final selected = controller.selectedCategoryIndex.value == i;
                  return CategoryItem(
                    title: category.name,
                    image: category.url,
                    selected: selected,
                    onTap: () => controller.selectCategory(i),
                  );
                },
              );
            }),
          ),

          const SizedBox(height: 10),

          /// PRODUCTS
          Expanded(
            child: Obx(() {
              final isLoading = controller.isLoadingProducts.value;
              final hasError = controller.productsError.value.isNotEmpty;
              final hasProducts = controller.productList.isNotEmpty;

              if (isLoading && !hasProducts) {
                return const SingleChildScrollView(
                  child: ProductsShimmer(),
                );
              }
              if (hasError && !hasProducts) {
                return _ProductErrorSection(
                  message: controller.productsError.value,
                  onRetry: controller.retryProducts,
                );
              }
              if (!hasProducts) {
                return const Center(
                  child: Text(
                    "No products yet",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return GridView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: controller.productList.length +
                    (controller.hasMore ? 1 : 0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: .72,
                ),
                itemBuilder: (_, i) {
                  if (i >= controller.productList.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final product = controller.productList[i];
                  return ProductCardWidget(
                    product: product,
                    onTap: () {},
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CategoryErrorSection extends StatelessWidget {
  const _CategoryErrorSection({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 40,
              color: Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text("Retry"),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductErrorSection extends StatelessWidget {
  const _ProductErrorSection({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text("Retry"),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}