import 'package:get/get.dart';
import '../models/sub_category.dart';

class SubCategoryController extends GetxController {
  var subCategories = <SubCategory>[].obs;
  var selectedSubCategoryIndex = 0.obs;

  void setSubCategories(List<dynamic> subCategoryList) {
    subCategories.value = subCategoryList
      .map((sc) => SubCategory(
        id: sc['id'] ?? 0,
        name: sc['name'] ?? '',
        image: sc['image'] ?? '',
        products: sc['products'] ?? [],
      ))
      .toList();
  }

  int getSubCategoryTotalQuantity(SubCategory subCat) {
  int total = 0;
  for (final product in subCat.products) {
    total = total + product['quantity'] as int? ?? 0;
  }
  return total;
}
}