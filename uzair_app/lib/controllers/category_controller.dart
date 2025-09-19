import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;
  var selectedCategoryIndex = 0.obs;
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
        final data = jsonDecode(response.body) as List;
        categories.value = data.map((cat) => Category(
          id: cat['id'] ?? 0,
          name: cat['name'] ?? '',
          subCategory: cat['subCategory'] ?? [],
        )).toList();
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

  int getCategoryTotalQuantity(Category category) {
    int total = 0;
    for (final subCat in category.subCategory) {
      final products = subCat['products'] as List<dynamic>? ?? [];
      for (final product in products) {
        final qty = product['quantity'] as int? ?? 0;
        total = total + qty;
      }
    }
    return total;
  }
}