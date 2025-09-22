import 'package:get/get.dart';
import '../models/product.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;

  void setProducts(List<dynamic> productList, String categoryName) {
    products.value = productList
      .map((p) => Product(
        id: p['id'] ?? 0,
        name: p['name'] ?? '',
        price: (p['price'] ?? 0).toDouble(),
        discountPercentage: p['discountPercentage'] != null
            ? (p['discountPercentage'] as num).toDouble()
            : null,
        image: p['image'],
        status: p['status'] ?? true,
      ))
      .toList();
  }

  double getDiscountedPrice(Product product) {
  final discount = product.discountPercentage ?? 0;

  if (discount > 0) {
    return product.price * (1 - discount / 100);
  }

  return product.price;
}
}