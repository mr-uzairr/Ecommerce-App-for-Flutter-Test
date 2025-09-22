import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';

String fixImageUrl(String url) {
  return url.replaceAll(
    "https://github.com/Mudassar1999/TPFlutterTest/blob/main",
    "https://raw.githubusercontent.com/Mudassar1999/TPFlutterTest/main",
  );
}

class ProductList extends StatelessWidget {
  final String selectedSubCategory;
  final List<Product> products;

  const ProductList({
    Key? key,
    required this.selectedSubCategory,
    required this.products,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Text(
                "Products",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  height: 30.h / 16.sp,
                  letterSpacing: -0.21.sp,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 13),
                child: Text(
                  " ($selectedSubCategory)",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w700,
                    fontSize: 7.sp,
                    height: 30.h / 7.sp,
                    letterSpacing: -0.21.sp,
                    color: Color(0xFFB9202B),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 240.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Container(
                width: 151.w,
                height: 225.h,
                margin: EdgeInsets.only(
                  right: 16.0,
                  left: index == 0 ? 0.0 : 0.0,
                ),
                child: ProductCard(product: products[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final discountedPrice = productController.getDiscountedPrice(product);

    return Container(
      width: 151.w,
      height: 225.h,
      margin: const EdgeInsets.only(right: 16.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 151.w,
                height: 150.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: product.image != null && product.image!.isNotEmpty
                      ? Image.network(
                          fixImageUrl(product.image!),
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey,
                            );
                          },
                        )
                      : const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  product.name,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 11.sp,
                    height: 1.0,
                    letterSpacing: 0,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 13.sp,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "\$${discountedPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 13.sp,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Color(0xFFB9202B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (!product.status)
                Center(
                  child: Container(
                    width: 146.65.w,
                    height: 12.84.h,
                    decoration: BoxDecoration(
                      color: const Color(0x4DFFCD03),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 115.16.w,
                      height: 12.64.h,

                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC107),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "sold out",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 9.sp,
                          height: 1.0,
                          letterSpacing: 0,
                          color: Color(0xFFB9202B),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (product.discountPercentage != null &&
              product.discountPercentage! > 0)
            Positioned(
              top: 6.h,
              left: 6.w,
              child: Opacity(
                opacity: 1,
                child: Transform.rotate(
                  angle: 0,
                  child: Container(
                    width: 40.w,
                    height: 15.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF28A745),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                    child: Text(
                      "-${(product.discountPercentage ?? 0).toStringAsFixed(2)}%",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 9.sp,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
