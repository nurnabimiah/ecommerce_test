
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/home/controller/product_controller.dart';
import '../../features/home/data/model/product_response_model.dart';



class ProductCardWidget extends StatefulWidget {
  const ProductCardWidget({
    super.key,
    required this.product,
    this.onTap,
  });

  final Product product;
  final VoidCallback? onTap;

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  final controller = Get.find<ProductController>();

  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ],
        ),
        child: Stack(
          children: [

            /// BODY
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// IMAGE
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: product.thumbnail.isEmpty
                          ? const Icon(Icons.image, size: 40)
                          : Image.network(
                        product.thumbnail,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// NAME
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// PRICE
                      Row(
                        children: [
                          Text(
                            "\$${product.price}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "\$${product.price}",
                            style: const TextStyle(
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      /// RATING
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 14, color: Colors.orange),
                          Text(
                            " ${product.rating}",
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ],
            ),

            /// DISCOUNT
            if (product.discountPercentage > 0)
              Positioned(
                top: 8,
                left: 0,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(8)),
                  ),
                  child: Text(
                    "${product.discountPercentage.toStringAsFixed(0)}% OFF",
                    style: const TextStyle(
                        color: Colors.white, fontSize: 10),
                  ),
                ),
              ),

            /// FAVORITE
            Positioned(
              top: 6,
              right: 6,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white,
                  child: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 16,
                    color: Colors.red,
                  ),
                ),
              ),
            ),

            /// CART BUTTON
            Positioned(
              bottom: 6,
              right: 6,
              child: Obx(() {
                bool inCart = controller.isInCart(product.id);

                return InkWell(
                  onTap: () {
                    controller.toggleCart({
                      "id": product.id,
                      "title": product.title,
                      "price": product.price,
                      "image": product.thumbnail,
                    });
                  },
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: inCart ? Colors.red : Colors.blue,
                    ),
                    child: Icon(
                      inCart
                          ? Icons.remove
                          : Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                );
              }),
            ),

            /// STOCK OUT
            if (product.stock == 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade700,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "Stock Out",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}