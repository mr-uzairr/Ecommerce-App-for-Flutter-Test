import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
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
      appBar: PreferredSize(
        preferredSize: const Size(320, 37),
        child: AppBar(
          toolbarHeight: 37,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Center(
            child: SvgPicture.asset(
              'assets/svgs/logo.svg',
              width: 130.75,
              height: 30.08,
              fit: BoxFit.contain,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              width: 37,
              height: 37,
              child: Opacity(
                opacity: 1,
                child: Transform.rotate(
                  angle: 0,
                  child: SvgPicture.asset(
                    'assets/svgs/menu.svg',
                    width: 37,
                    height: 37,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                width: 37,
                height: 37,
                child: Opacity(
                  opacity: 1,
                  child: Transform.rotate(
                    angle: 0,
                    child: SvgPicture.asset(
                      'assets/svgs/search.svg',
                      width: 37,
                      height: 37,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
         if (categoryController.isLoading.value) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 200.w,
                    height: 30.h,
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: 16.h),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: 50.h,
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: 16.h),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: 240.h,
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: 16.h),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 320.w,
                    height: 80.h,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }


        final categories = categoryController.categories;
        final selectedCategoryIndex =
            categoryController.selectedCategoryIndex.value;
        final selectedCategory = categories.isNotEmpty
            ? categories[selectedCategoryIndex]
            : null;

        if (selectedCategory != null) {
          subCategoryController.setSubCategories(selectedCategory.subCategory);
        }

        final subCategories = subCategoryController.subCategories;
        final selectedSubCategoryIndex =
            subCategoryController.selectedSubCategoryIndex.value;
        final selectedSubCategory = subCategories.isNotEmpty
            ? subCategories[selectedSubCategoryIndex]
            : null;

        if (selectedSubCategory != null) {
          productController.setProducts(
            selectedSubCategory.products,
            selectedSubCategory.name,
          );
        }

        return Column(
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFECF1F3), width: 1.5),
                  bottom: BorderSide(color: Color(0xFFECF1F3), width: 1.5),
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
                        final totalQty = categoryController
                            .getCategoryTotalQuantity(category);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () {
                              categoryController.selectedCategoryIndex.value =
                                  index;
                              subCategoryController
                                      .selectedSubCategoryIndex
                                      .value =
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
                                          categoryController
                                                  .selectedCategoryIndex
                                                  .value ==
                                              index
                                          ? Colors.red
                                          : Color(0xFFECF1F3),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    category.name,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:
                                          categoryController
                                                  .selectedCategoryIndex
                                                  .value ==
                                              index
                                          ? FontWeight.w700
                                          : FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.sp,
                                      height: 1.0,
                                      letterSpacing: 0,
                                      color:
                                          categoryController
                                                  .selectedCategoryIndex
                                                  .value ==
                                              index
                                          ? Colors.black
                                          : Color(0xFF89999F),
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
                                              categoryController
                                                      .selectedCategoryIndex
                                                      .value ==
                                                  index
                                              ? Colors.red
                                              : Color(0xFFD9E4E8),
                                          width: 1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '$totalQty',
                                        style: TextStyle(
                                          color:
                                              categoryController
                                                      .selectedCategoryIndex
                                                      .value ==
                                                  index
                                              ? Colors.black
                                              : const Color(0xFF98A6AB),
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
                          categoryController.selectedCategoryIndex.value,
                        ),
                        subCategories: subCategoryController.subCategories,
                        selectedIndex: subCategoryController
                            .selectedSubCategoryIndex
                            .value,
                        onSubCategoryTap: (index) {
                          subCategoryController.selectedSubCategoryIndex.value =
                              index;
                        },
                        getSubCategoryTotalQuantity:
                            subCategoryController.getSubCategoryTotalQuantity,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Obx(
                              () => ProductList(
                                key: ValueKey(
                                  subCategoryController
                                      .selectedSubCategoryIndex
                                      .value,
                                ),
                                selectedSubCategory:
                                    selectedSubCategory?.name ?? '',
                                products: productController.products,
                              ),
                            ),
                            Container(
                              width: 320.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF17A2B8),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Opacity(
                                opacity: 1,
                                child: Transform.rotate(
                                  angle: 0,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 14.w),
                                        child: Container(
                                          width: 49.w,
                                          height: 48.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                            child: Image.asset(
                                              'assets/images/delivery.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 12.w),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Free Shipping Over \$0',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight:
                                                      FontWeight.w600,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 15.sp,
                                                  height: 1.0,
                                                  letterSpacing: 0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 2.h),
                                              Text(
                                                'Free returns and exchange',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight:
                                                      FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 12.sp,
                                                  height: 1.0,
                                                  letterSpacing: 0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 14.w),
                                        child: SvgPicture.asset(
                                          'assets/svgs/call.svg',
                                          width: 40.w,
                                          height: 40.h,
                                        ),
                                      ),
                                    ],
                                  ),
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
            ),
          ],
        );
      }),
    );
  }
}
