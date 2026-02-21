

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/product_card_widgets.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../controller/product_controller.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home_screen';
  HomeScreen({super.key});

  final controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,

      /// APP BAR
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

          /// CATEGORY
          // SizedBox(
          //   height: 90,
          //   child: Obx(() => ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     padding: const EdgeInsets.symmetric(horizontal: 12),
          //     itemCount: controller.categories.length,
          //     itemBuilder: (_, i) {
          //       var category = controller.categories[i];
          //
          //       bool selected =
          //           controller.selectedCategory.value == category["id"];
          //
          //       return GestureDetector(
          //         onTap: () => controller.selectCategory(category["id"]),
          //         child: Container(
          //           width: 80,
          //           margin: const EdgeInsets.only(right: 12),
          //           padding: const EdgeInsets.all(8),
          //           decoration: BoxDecoration(
          //             gradient:
          //             selected ? AppColors.gradient : null,
          //             color:
          //             selected ? null : Colors.white,
          //             borderRadius:
          //             BorderRadius.circular(14),
          //             border: Border.all(
          //               color: AppColors.primary
          //                   .withValues(alpha: 0.25),
          //             ),
          //           ),
          //           child: Column(
          //             mainAxisAlignment:
          //             MainAxisAlignment.center,
          //             children: [
          //               Container(
          //                 height: 40,
          //                 width: 40,
          //                 color: Colors.grey.shade200,
          //                 child: const Icon(Icons.category),
          //               ),
          //               const SizedBox(height: 6),
          //               Text(
          //                 category["name"],
          //                 maxLines: 1,
          //                 overflow:
          //                 TextOverflow.ellipsis,
          //                 style: TextStyle(
          //                   fontSize: 12,
          //                   color: selected
          //                       ? Colors.white
          //                       : Colors.black,
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //   )),
          // ),

          const SizedBox(height: 10),

          /// PRODUCTS
          Expanded(
            child: Obx(() {
              return GridView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: controller.productList.length + (controller.hasMore ? 1 : 0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: .72,
                ),

                itemBuilder: (_, i) {
                  if (i >= controller.productList.length) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var product = controller.productList[i];

                  return ProductCardWidget(
                    product: product,
                    onTap: () {},
                  );
                },

                // itemBuilder: (_, i) {
                //   if (i >= controller.productList.length) {
                //     return const Center(
                //       child: CircularProgressIndicator(),
                //     );
                //   }
                //
                //   var product = controller.productList[i];
                //
                //   return ProductCardWidget(
                //     productId: product.id,
                //     imageUrl: product.thumbnail,
                //     productName: product.title,
                //     discountPrice: product.price,
                //     productPrice: product.price,
                //     rating: product.rating,
                //     stock: product.stock,
                //     percentage: product.discountPercentage,
                //     onTap: () {},
                //   );
                // },
              );
            }),
          ),
        ],
      ),
    );
  }
}