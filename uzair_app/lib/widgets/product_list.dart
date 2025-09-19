import 'package:flutter/material.dart';

String fixImageUrl(String url) {
  return url.replaceAll(
    "https://github.com/Mudassar1999/TPFlutterTest/blob/main",
    "https://raw.githubusercontent.com/Mudassar1999/TPFlutterTest/main",
  );
}

class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final double? discountPercentage;
  final String? image;
  final bool status;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.discountPercentage,
    this.image,
    required this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json, {String category = ""}) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      category: category,
      price: (json['price'] ?? 0.0).toDouble(),
      discountPercentage: json['discountPercentage'] != null
          ? (json['discountPercentage'] as num).toDouble()
          : null,
      image: json['image'],
      status: json['status'] ?? true,
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final discountedPrice =
        (product.discountPercentage != null && product.discountPercentage! > 0)
        ? product.price * (1 - product.discountPercentage! / 100)
        : product.price;

    return Container(
      width: 190,
      margin: const EdgeInsets.only(right: 16.0),
     
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              Container(
                width: double.infinity,
                height: 210, 
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
                  product.category.isNotEmpty ? product.category : "Category",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "\$${discountedPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                        letterSpacing: -0.21,
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8), 
              if (!product.status)
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 18,
                    margin: const EdgeInsets.symmetric(
                      horizontal:5,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 150,
                      height: 20,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "sold out",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
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
              top: 7,
              left: 5,
              child: Container(
                width: 50,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  "-${product.discountPercentage!.toStringAsFixed(2)}%",
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}class ProductList extends StatelessWidget {
  final String selectedSubCategory;
  final List<Product> products;

  const ProductList({
    Key? key,
    required this.selectedSubCategory,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: "Products ",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: "($selectedSubCategory)",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(product: product);
            },
          ),
        ),
      ],
    );
  }
}