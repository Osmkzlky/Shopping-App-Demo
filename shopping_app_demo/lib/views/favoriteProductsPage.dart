// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app_demo/components/customCard.dart';
import 'package:shopping_app_demo/controllers/productDetailPageController.dart';
import 'package:shopping_app_demo/helpers/size.dart';
import 'package:shopping_app_demo/models/Product.dart';
import 'package:shopping_app_demo/models/UserData.dart';
import 'package:shopping_app_demo/services/firebase_services.dart';

class FavoriteProductsPage extends StatelessWidget {
  final UserData userData;
  final productDetailPageController = Get.put(ProductDetailPageController());

  FavoriteProductsPage({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Products>(
          future: FirebaseServices().getAllProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              Products products = snapshot.data!;
              return Column(
                children: [
                  Text(
                    "Favorilerim (${userData.favoriteProductIds.length})",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                  ),
                  const Divider(),
                  SizedBox(
                      height: 25.h,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: userData.favoriteProductIds.length,
                          itemBuilder: (context, index) {
                            Product product = products.products[
                                int.parse(userData.favoriteProductIds[index])];
                            final formattedPrice = NumberFormat.currency(
                              locale: 'tr_TR', // Türkçe Türkiye yerel ayarları
                              symbol: '', // TL simgesi
                              decimalDigits: 0, // Ondalık basamak sayısı
                            ).format(
                                int.parse(product.product_prices.values.first));
                            return SizedBox(
                                child: CustomCard(
                                    product: product,
                                    formatPrice: formattedPrice));
                          })),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "Son Gezdiklerim",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                  ),
                  const Divider(),
                  SizedBox(
                      height: 25.h,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productDetailPageController
                              .lastVisitedList.length,
                          itemBuilder: (context, index) {
                            Product product = products.products[int.parse(
                                productDetailPageController.lastVisitedList[
                                    productDetailPageController
                                            .lastVisitedList.length -
                                        (index + 1)])];
                            final formattedPrice = NumberFormat.currency(
                              locale: 'tr_TR', // Türkçe Türkiye yerel ayarları
                              symbol: '', // TL simgesi
                              decimalDigits: 0, // Ondalık basamak sayısı
                            ).format(
                                int.parse(product.product_prices.values.first));
                            return SizedBox(
                                child: CustomCard(
                                    product: product,
                                    formatPrice: formattedPrice));
                          })),
                ],
              );
            } else {
              return Text("Veri Bulunamadı");
            }
          }),
    );
  }
}
