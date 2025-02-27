// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shopping_app_demo/helpers/size.dart';
import 'package:shopping_app_demo/models/Shopping.dart';
import 'package:shopping_app_demo/services/firebase_services.dart';
import 'package:shopping_app_demo/theme/colors.dart';
import 'package:shopping_app_demo/views/productRiviewPage.dart';

class OrdersPage extends StatelessWidget {
  final String userId;
  const OrdersPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Siparişlerim"),
      ),
      body: StreamBuilder<List<Shopping>>(
          stream: FirebaseServices().getShoppingList(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              List<Shopping> shoppingList = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: shoppingList.length,
                        itemBuilder: (context, index) {
                          Shopping shopping = shoppingList[index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 2.w),
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            height: 17.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: blue),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                            height: 10.h,
                                            width: 30.w,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1.h),
                                              child: Image.network(
                                                  shopping.product_image),
                                            )),
                                        SizedBox(
                                          width: 30.w,
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            "SD:${shopping.shopping_status}",
                                            style: TextStyle(
                                                color: blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: 30.w,
                                          child: Text(
                                            shopping.product_name,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                          width: 30.w,
                                          child: ListView.builder(
                                              itemCount: shopping
                                                  .additionalServices.length,
                                              itemBuilder: (context, index) {
                                                Map additionalService = shopping
                                                    .additionalServices[index];
                                                return RichText(
                                                    text: TextSpan(
                                                        style: TextStyle(
                                                            color: black,
                                                            fontSize: 13.sp),
                                                        children: [
                                                      TextSpan(
                                                          text: additionalService[
                                                              "additionalService_name"]),
                                                      TextSpan(
                                                          text:
                                                              "+${additionalService["additionalService_price"]}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ]));
                                              }),
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(shopping.shopping_date),
                                        Text(
                                          "${shopping.product_price.values.first} TL",
                                          style: const TextStyle(
                                              color: blue,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 1.h),
                                  child: SizedBox(
                                    width: 70.w,
                                    height: 3.h,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                shopping.shopping_status ==
                                                        "Teslim Edildi"
                                                    ? blue
                                                    : gray),
                                        onPressed: () {
                                          shopping.shopping_status ==
                                                  "Teslim Edildi"
                                              ? Get.to(ProductRiviewPage(
                                                  shopping: shopping))
                                              : null;
                                        },
                                        child: const Text(
                                          "Ürünü değerlendir",
                                          style: TextStyle(color: white),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              );
            } else {
              return const Text("Veri Bulunamadı");
            }
          }),
    );
  }
}
