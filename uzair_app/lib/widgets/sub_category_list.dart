import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../models/sub_category.dart';
import '../controllers/sub_category_controller.dart';

class SubCategoryList extends StatelessWidget {
  final List<SubCategory> subCategories;
  final int selectedIndex;
  final Function(int)? onSubCategoryTap;

  const SubCategoryList({
    super.key,
    required this.subCategories,
    this.selectedIndex = 0,
    this.onSubCategoryTap,
    required int Function(SubCategory subCat) getSubCategoryTotalQuantity,
  });

  String fixImageUrl(String url) {
    return url.replaceAll(
      "https://github.com/Mudassar1999/TPFlutterTest/blob/main",
      "https://raw.githubusercontent.com/Mudassar1999/TPFlutterTest/main",
    );
  }

  @override
  Widget build(BuildContext context) {
    final subCategoryController = Get.find<SubCategoryController>();

    return subCategories.isEmpty
        ? const Center(child: Text("No subcategories"))
        : SizedBox(
            width: 325.w,
            height: 105.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subCategories.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final subCat = subCategories[index];
                final totalQty = subCategoryController
                    .getSubCategoryTotalQuantity(subCat);

                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0.0 : 1.0,
                    right: 1.0,
                    top: 20.0,
                    bottom: 8.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (onSubCategoryTap != null) {
                        onSubCategoryTap!(index);
                      }
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          width: 50.47.w,
                          height: 50.47.h,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selectedIndex == index
                                        ? Colors.red
                                        : Color(0xFF98A6AB),
                                         width: 1.5.w,
                                  ),
                                  color: Colors.white,
                                ),
                                alignment: Alignment.center,
                                child: ClipOval(
                                  child: Image.network(
                                    fixImageUrl(subCat.image),
                                    width: 45.w,
                                    height: 45.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (totalQty > 0)
                                Positioned(
                                  left: 35.w,
                                  child: Opacity(
                                    opacity: 1,
                                    child: Transform.rotate(
                                      angle: 0,
                                      child: Container(
                                        width: 14.w,
                                        height: 14.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: selectedIndex == index
                                                ? Colors.red
                                                : const Color(0xFF98A6AB),
                                            width: 1.5.w,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '$totalQty',
                                          style: TextStyle(
                                            color: selectedIndex == index
                                                ? Colors.black
                                                : const Color(0xFF98A6AB),
                                            fontSize: 5.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 70,
                          child: Text(
                            subCat.name,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: selectedIndex == index
                                  ? FontWeight.w400
                                  : FontWeight.normal,
                              fontSize: 11.sp,
                              height: 1.0,
                              letterSpacing: 0,
                              color: const Color(0xFF89999F),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}
