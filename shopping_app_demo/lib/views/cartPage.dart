import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app_demo/controllers/customBottomNavigationBarController.dart';
import 'package:shopping_app_demo/controllers/productDetailPageController.dart';
import 'package:shopping_app_demo/helpers/size.dart';
import 'package:shopping_app_demo/models/Shopping.dart';
import 'package:shopping_app_demo/services/firebase_services.dart';
import 'package:shopping_app_demo/theme/colors.dart';

class CartPage extends StatelessWidget {
  final productDetailPageController = Get.put(ProductDetailPageController());
  final customBottomNavigationBarController =
      Get.put(CustomBottomNavigationBarController());
  CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Ürün Listesi",
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const Divider(),
        SizedBox(
            height: 50.h,
            child: Obx(
              () => ListView.builder(
                  itemCount: productDetailPageController.shoppingList.length,
                  itemBuilder: (context, index) {
                    Shopping shopping =
                        productDetailPageController.shoppingList[index];

                    return SizedBox(
                      height: 15.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: Row(
                              children: [
                                SizedBox(
                                    height: 15.h,
                                    width: 20.w,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      child:
                                          Image.network(shopping.product_image),
                                    )),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(shopping.product_name,
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold)),
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                color: black,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w500),
                                            children: [
                                          TextSpan(
                                            text:
                                                "${shopping.product_price.keys.first} / ",
                                          ),
                                          TextSpan(
                                            text: shopping.product_color,
                                          )
                                        ])),
                                    Text(
                                      "Ek Hizmetler",
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    SizedBox(
                                        height: 0.1.h,
                                        width: 40.w,
                                        child: const Divider()),
                                    SizedBox(
                                      height: 7.h,
                                      width: 50.w,
                                      child: ListView.builder(
                                          itemCount: shopping
                                              .additionalServices.length,
                                          itemBuilder: (context, index2) =>
                                              RichText(
                                                  text: TextSpan(
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 15.sp),
                                                      children: [
                                                    const TextSpan(text: "﹒"),
                                                    TextSpan(
                                                        text: shopping
                                                                    .additionalServices[
                                                                index2][
                                                            "additionalService_name"]),
                                                    TextSpan(
                                                        text:
                                                            " +${shopping.additionalServices[index2]["additionalService_price"]} TL",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                                  ]))),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  "${shopping.product_price.values.first} TL",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )),
        const Divider(),
        GestureDetector(
          onTap: () {
            customBottomNavigationBarController.updateBottomIndex(0);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: const Text(
              "Alışverişe devam etmek ister misin?",
              style:
                  TextStyle(decoration: TextDecoration.underline, color: blue),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tutar:",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "${productDetailPageController.totalPrice.value} TL",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        SizedBox(
          height: 5.h,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: blue),
                onPressed: () async {
                  await FirebaseServices().saveShoppingList(
                      productDetailPageController.shoppingList);
                  productDetailPageController.shoppingList.value = [];
                },
                child: Text(
                  "Ödeme Ekranına Geç",
                  style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.sp),
                )),
          ),
        )
      ],
    ));
  }
}
