import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/category_card_widget.dart';
import '../../../../common/widgets/product_card_widgets.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../controller/product_controller.dart';
import '../widgets/categories_shimmer.dart';
import '../widgets/product_error_widget.dart';
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
        title: const Text("Trendify"),
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

      body: RefreshIndicator(
        onRefresh: () async {

          controller.selectedCategoryIndex.value = -1;
          controller.selectedCategorySlug = null;

          controller.skip = 0;
          controller.hasMore = true;
          controller.productList.clear();

          if (controller.selectedCategorySlug != null) {
            await controller.getProductsByCategory(controller.selectedCategorySlug!);
          } else {
            await controller.getAllProductsInfo();
          }
        },

        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
        
            ///  CATEGORIES TITLE
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        
            ///  CATEGORIES LIST
            SliverToBoxAdapter(
              child: Obx(() {
                if (controller.isLoadingCategories.value) {
                  return const SizedBox(
                    height: 90,
                    child: CategoriesShimmer(),
                  );
                }
        
                if (controller.categories.isEmpty) {
                  return const SizedBox.shrink();
                }
        
                return SizedBox(
                  height: 90.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: controller.categories.length,
                    itemBuilder: (_, i) {
                      final category = controller.categories[i];
        
                      return Obx(() {
                        final selected =
                            controller.selectedCategoryIndex.value == i;
        
                        return CategoryItem(
                          title: category.name,
                          image: category.url,
                          selected: selected,
                          onTap: () {
                            controller.selectCategory(i);
                          },
                        );
                      });
                    },
                  ),
                );
              }),
            ),
        
            const SliverToBoxAdapter(
              child: SizedBox(height: 12),
            ),
        
            /// PRODUCTS TITLE
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  "Products",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        
            /// PRODUCTS GRID
            Obx(() {
              final isLoading = controller.isLoadingProducts.value;
              final hasError = controller.productsError.value.isNotEmpty;
              final hasProducts = controller.productList.isNotEmpty;
        
              if (isLoading && !hasProducts) {
                return const SliverToBoxAdapter(
                  child: ProductsShimmer(),
                );
              }
        
              if (hasError && !hasProducts) {
                return SliverToBoxAdapter(
                  child: ProductErrorSection(
                    message: controller.productsError.value,
                    onRetry: controller.retryProducts,
                  ),
                );
              }
        
              if (!hasProducts) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text("No products yet"),
                    ),
                  ),
                );
              }
        
              return SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (_, i) {
                      if (i >= controller.productList.length) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
        
                      final product = controller.productList[i];
        
                      return ProductCardWidget(
                        product: product,
                        onTap: () {},
                      );
                    },
                    childCount: controller.productList.length +
                        (controller.hasMore ? 1 : 0),
                  ),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: .72,
                  ),
                ),
              );
            }),
          ],
        ),
      ),

    );
  }
}


