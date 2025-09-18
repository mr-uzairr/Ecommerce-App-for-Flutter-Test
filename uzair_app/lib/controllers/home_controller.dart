import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var selectedCategoryIndex = 0.obs;
  var selectedSubCategoryIndex = 0.obs;
  var categories = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse("https://tp-flutter-test.vercel.app/v1/category"),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        categories.value = data;
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

  int getCategoryTotalQuantity(Map<String, dynamic> category) {
    final subCategories = category['subCategory'] as List<dynamic>?;
    if (subCategories == null) return 0;
    int total = 0;
    for (final subCat in subCategories) {
      final products = subCat['products'] as List<dynamic>?;
      if (products == null) continue;
      for (final product in products) {
        final qty = product['quantity'] as int?;
        if (qty != null) {
          total = total + qty;
        }
      }
    }
    return total;
  }

  List<dynamic> getSelectedSubCategoryProducts() {
    if (categories.isEmpty ||
        categories[selectedCategoryIndex.value]['subCategory'] == null ||
        (categories[selectedCategoryIndex.value]['subCategory'] as List).isEmpty) {
      return [];
    }
    final subCategory =
        categories[selectedCategoryIndex.value]['subCategory'][selectedSubCategoryIndex.value];
    return subCategory['products'] ?? [];
  }

  String getSelectedSubCategoryName() {
    if (categories.isEmpty ||
        categories[selectedCategoryIndex.value]['subCategory'] == null ||
        (categories[selectedCategoryIndex.value]['subCategory'] as List).isEmpty) {
      return '';
    }
    return categories[selectedCategoryIndex.value]['subCategory'][selectedSubCategoryIndex.value]['name'] ?? '';
  }
}