import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/home_controller.dart';
import '../widgets/sub_category_list.dart';
import '../widgets/product_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

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
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                            ...List.generate(controller.categories.length, (
                              index,
                            ) {
                              final category = controller.categories[index];
                              final totalQty = controller
                                  .getCategoryTotalQuantity(category);

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    controller.selectedCategoryIndex.value =
                                        index;
                                    controller.selectedSubCategoryIndex.value =
                                        0;
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                controller
                                                        .selectedCategoryIndex
                                                        .value ==
                                                    index
                                                ? Colors.red
                                                : Colors.grey,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                          color:
                                              controller
                                                      .selectedCategoryIndex
                                                      .value ==
                                                  index
                                              ? Colors.red.withOpacity(0.1)
                                              : Colors.transparent,
                                        ),
                                        child: Text(
                                          category['name'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                controller
                                                        .selectedCategoryIndex
                                                        .value ==
                                                    index
                                                ? Colors.black
                                                : Colors.grey,
                                            fontWeight:
                                                controller
                                                        .selectedCategoryIndex
                                                        .value ==
                                                    index
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
                                                color:
                                                    controller
                                                            .selectedCategoryIndex
                                                            .value ==
                                                        index
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
                              key: ValueKey(
                                controller.selectedCategoryIndex.value,
                              ),
                              subCategories: controller.categories.isNotEmpty
                                  ? controller.categories[controller
                                            .selectedCategoryIndex
                                            .value]['subCategory'] ??
                                        []
                                  : [],
                              selectedIndex:
                                  controller.selectedSubCategoryIndex.value,
                              onSubCategoryTap: (index) {
                                controller.selectedSubCategoryIndex.value =
                                    index;
                              },
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Obx(
                                    () => ProductList(
                                      key: ValueKey(
                                        controller
                                            .selectedSubCategoryIndex
                                            .value,
                                      ),
                                      selectedSubCategory: controller
                                          .getSelectedSubCategoryName(),
                                      products: controller
                                          .getSelectedSubCategoryProducts()
                                          .map(
                                            (p) => Product(
                                              id: p['id'] ?? 0,
                                              name: p['name'] ?? '',
                                              category:
                                                  p['category'] ??
                                                  controller
                                                      .getSelectedSubCategoryName(),
                                              price: (p['price'] ?? 0)
                                                  .toDouble(),
                                              discountPercentage:
                                                  p['discountPercentage'] !=
                                                      null
                                                  ? (p['discountPercentage']
                                                            as num)
                                                        .toDouble()
                                                  : null,
                                              image: p['image'],
                                              status: p['status'] ?? true,
                                            ),
                                          )
                                          .toList(), 
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 20,
                                    ),
                                    width: double.infinity,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.cyan,
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 12.0,
                                              ),
                                              child: Container(
                                                width: 46,
                                                height: 46,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  child: Image.asset(
                                                    'assets/delivery.png',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 30),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Text(
                                                  'Free Shipping Over \$0',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  'Free returns and exchange',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12.0,
                                          ),
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
              ),
      ),
    );
  }
}
