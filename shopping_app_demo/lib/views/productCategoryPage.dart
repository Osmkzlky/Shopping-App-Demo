// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:shopping_app_demo/helpers/size.dart';
import 'package:shopping_app_demo/models/Product.dart';
import 'package:shopping_app_demo/models/UserData.dart';
import 'package:shopping_app_demo/theme/colors.dart';
import 'package:shopping_app_demo/views/productListPage.dart';

class ProductCategoryPage extends StatelessWidget {
  final UserData userData;
  const ProductCategoryPage({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        _buildCard(
            categoryName: "Telefon",
            imagePath: "assets/images/iphone15pro.png",
            products: phone_ids),
        _buildCard(
            categoryName: "Bilgisayar",
            imagePath: "assets/images/mba13_m3.png",
            products: computer_ids),
        _buildCard(
            categoryName: "Tablet",
            imagePath: "assets/images/ipadpro11.png",
            products: tablet_ids),
        _buildCard(
            categoryName: "Saat",
            imagePath: "assets/images/watch_s9.png",
            products: watch_ids),
        _buildCard(
            categoryName: "Aksesuar",
            imagePath: "assets/images/case.png",
            products: accessory_ids)
      ],
    ));
  }

  Widget _buildCard(
      {required String imagePath,
      required String categoryName,
      required List<String> products}) {
    return SizedBox(
      height: 20.h,
      child: GestureDetector(
        onTap: () {
          Get.to(ProductListPage(
            product_ids: products,
            title: categoryName,
          ));
        },
        child: Card(
          color: white,
          margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 35.w, height: 15.h, child: Image.asset(imagePath)),
              Text(
                categoryName,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              const Icon(FontAwesomeIcons.angleRight)
            ],
          ),
        ),
      ),
    );
  }
}
