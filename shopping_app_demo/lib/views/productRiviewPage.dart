// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shopping_app_demo/controllers/productRiviewPageController.dart';
import 'package:shopping_app_demo/helpers/size.dart';

import 'package:shopping_app_demo/models/Shopping.dart';
import 'package:shopping_app_demo/services/firebase_services.dart';
import 'package:shopping_app_demo/theme/colors.dart';

class ProductRiviewPage extends StatefulWidget {
  final Shopping shopping;
  ProductRiviewPage({
    Key? key,
    required this.shopping,
  }) : super(key: key);

  @override
  State<ProductRiviewPage> createState() => _ProductRiviewPageState();
}

class _ProductRiviewPageState extends State<ProductRiviewPage> {
  final productRiviewPageController = Get.put(ProductRiviewPageController());
  @override
  void initState() {
    productRiviewPageController.starIndex.value = 0;
    print("shopping ${widget.shopping.product_id}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shopping.product_name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 5.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (contex, index) => GestureDetector(
                          onTap: () {
                            productRiviewPageController.starIndex.value =
                                index + 1;
                          },
                          child: Obx(() => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1.w),
                                child: Icon(
                                  index <
                                          productRiviewPageController
                                              .starIndex.value
                                      ? FontAwesomeIcons.solidStar
                                      : FontAwesomeIcons.star,
                                  size: 25.sp,
                                  color: orange,
                                ),
                              )))),
                )),
            Obx(() => Text(
                  "${productRiviewPageController.starIndex.value} Yıldız",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
              child: TextFormField(
                controller: productRiviewPageController.commentController,
                maxLines: 7,
                maxLength: 1000,
                decoration: const InputDecoration(
                    hintText: "Ürünle ilgili düşüncelerin",
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: SizedBox(
                width: 70.w,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: orange),
                    onPressed: () {
                      String text = "";
                      if (int.parse(widget.shopping.product_id) < 10) {
                        text = "0" + "." + widget.shopping.product_id;
                        print(text);
                      } else {
                        text = widget.shopping.product_id[0] +
                            "." +
                            widget.shopping.product_id[1];
                      }
                      print(text);

                      FirebaseServices().addProductReview(
                          product_id: text,
                          star: productRiviewPageController.starIndex.value
                              .toString(),
                          comment: productRiviewPageController
                              .commentController.text,
                          user_id: widget.shopping.user_id,
                          user_name: widget.shopping.user_name,
                          user_surname: widget.shopping.user_surname);
                    },
                    child: const Text(
                      "Gönder",
                      style:
                          TextStyle(color: white, fontWeight: FontWeight.bold),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
