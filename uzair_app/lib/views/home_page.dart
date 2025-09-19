import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/category_controller.dart';
import '../controllers/sub_category_controller.dart';
import '../controllers/product_controller.dart';
import '../widgets/sub_category_list.dart';
import '../widgets/product_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    final subCategoryController = Get.put(SubCategoryController());
    final productController = Get.put(ProductController());

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: true,
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 37,
          child: SvgPicture.asset('assets/Logo.svg', fit: BoxFit.contain),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SvgPicture.asset('assets/Menu.svg', width: 37, height: 37),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SvgPicture.asset('assets/Search.svg', width: 43, height: 43),
          ),
        ],
      ),
      body: Obx(
        () {
          if (categoryController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Set subcategories and products when category/subcategory changes
          final categories = categoryController.categories;
          final selectedCategoryIndex = categoryController.selectedCategoryIndex.value;
          final selectedCategory = categories.isNotEmpty ? categories[selectedCategoryIndex] : null;

          if (selectedCategory != null) {
            subCategoryController.setSubCategories(selectedCategory.subCategory);
          }

          final subCategories = subCategoryController.subCategories;
          final selectedSubCategoryIndex = subCategoryController.selectedSubCategoryIndex.value;
          final selectedSubCategory = subCategories.isNotEmpty ? subCategories[selectedSubCategoryIndex] : null;

          if (selectedSubCategory != null) {
            productController.setProducts(selectedSubCategory.products, selectedSubCategory.name);
          }

          return Column(
            children: [
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey, width: 1.5),
                    bottom: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                ),
                child: Opacity(
                  opacity: 1.0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        ...List.generate(categories.length, (index) {
                          final category = categories[index];
                          final totalQty = categoryController.getCategoryTotalQuantity(category);

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                categoryController.selectedCategoryIndex.value = index;
                                subCategoryController.selectedSubCategoryIndex.value = 0;
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: categoryController.selectedCategoryIndex.value == index
                                            ? Colors.red
                                            : Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                      color: categoryController.selectedCategoryIndex.value == index
                                          ? Colors.red.withOpacity(0.1)
                                          : Colors.transparent,
                                    ),
                                    child: Text(
                                      category.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: categoryController.selectedCategoryIndex.value == index
                                            ? Colors.black
                                            : Colors.grey,
                                        fontWeight: categoryController.selectedCategoryIndex.value == index
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  if (totalQty > 0)
                                    Positioned(
                                      top: -4,
                                      right: -6,
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: categoryController.selectedCategoryIndex.value == index
                                                ? Colors.red
                                                : Colors.grey,
                                            width: 1,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '$totalQty',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Obx(
                        () => SubCategoryList(
                          key: ValueKey(categoryController.selectedCategoryIndex.value),
                          subCategories: subCategoryController.subCategories,
                          selectedIndex: subCategoryController.selectedSubCategoryIndex.value,
                          onSubCategoryTap: (index) {
                            subCategoryController.selectedSubCategoryIndex.value = index;
                          },
                          getSubCategoryTotalQuantity: subCategoryController.getSubCategoryTotalQuantity,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Obx(
                                () => ProductList(
                                  key: ValueKey(subCategoryController.selectedSubCategoryIndex.value),
                                  selectedSubCategory: selectedSubCategory?.name ?? '',
                                  products: productController.products,
                                ),
                              ),
                              Container(
                                
                                width: double.infinity,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF17A2B8),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12.0),
                                          child: Container(
                                            width: 46,
                                            height: 46,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: Image.asset('assets/delivery.png'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 30),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Free Shipping Over \$0',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'Free returns and exchange',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12.0),
                                      child: SvgPicture.asset(
                                        'assets/Call.svg',
                                        width: 46,
                                        height: 46,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}