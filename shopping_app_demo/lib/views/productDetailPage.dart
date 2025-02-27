// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app_demo/controllers/customBottomNavigationBarController.dart';
import 'package:shopping_app_demo/controllers/customCardController.dart';

import 'package:shopping_app_demo/controllers/productDetailPageController.dart';
import 'package:shopping_app_demo/helpers/size.dart';
import 'package:shopping_app_demo/models/Product.dart';
import 'package:shopping_app_demo/models/Shopping.dart';
import 'package:shopping_app_demo/models/UserData.dart';
import 'package:shopping_app_demo/services/auth.dart';
import 'package:shopping_app_demo/theme/colors.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final productDetailPageController = Get.put(ProductDetailPageController());
  final customCardController = Get.put(CustomCardController());
  final customBottomNavigationBarController =
      Get.put(CustomBottomNavigationBarController());

  @override
  void initState() {
    // customPrice ilk değer ataması yapıyoruz atama yapmazsak 0 ile başlıyor
    productDetailPageController
        .updateCustomPrice(widget.product.product_prices.values.first);
    productDetailPageController.newAdditionalServicesList.value = <Map>[];
    productDetailPageController.colorIndex.value = 0;
    productDetailPageController.priceIndex.value = 0;

    productDetailPageController.addLastVisited(widget.product.product_id);
    productDetailPageController.starAverage.value = "0.0";

    productDetailPageController.starAverageFun(widget.product.product_reviews);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.product.product_name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            StreamBuilder<UserData?>(
                stream: Auth().getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    UserData userData = snapshot.data!;
                    for (int i = 0;
                        i < userData.favoriteProductIds.length;
                        i++) {
                      customCardController.isSaved.value = false;
                      if (widget.product.product_id ==
                          userData.favoriteProductIds[i]) {
                        customCardController.isSaved.value = true;
                        break;
                      }
                    }
                    return IconButton(
                        onPressed: () {
                          customCardController.updateIsSaved();
                          setState(() {});
                          if (customCardController.isSaved.value) {
                            Auth().addFavoriteProductId(
                                widget.product.product_id);
                          } else {
                            Auth().removeFavoriteProductId(
                                widget.product.product_id);
                          }
                        },
                        icon: customCardController.isSaved.value
                            ? const FaIcon(
                                FontAwesomeIcons.solidBookmark,
                                color: orange,
                              )
                            : const FaIcon(FontAwesomeIcons.bookmark));
                  } else {
                    return const Text("Veri Bulunamadı");
                  }
                })
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImage(),
            _buildColors(context),
            _buildPrices(context),
            _buildAdditionalServices(context),
            _buildInfo(context),
            _buildReviews(context)
          ],
        ),
      ),
      bottomNavigationBar: StreamBuilder<UserData?>(
          stream: Auth().getUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData userData = snapshot.data!;
              return Container(
                height: 10.h,
                padding: EdgeInsets.only(right: 2.w, left: 2.w, bottom: 2.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(0)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Obx(
                          () => Text(
                              "${productDetailPageController.customPrice.value} TL",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold)),
                        )),
                    const Spacer(),
                    _buildElevatedButton(
                        text: "Şimdi Al",
                        color: yellow,
                        press: () {
                          customBottomNavigationBarController
                              .bottomIndex.value = 2;
                          Get.back();
                          productDetailPageController.cartAdditionalServices();
                          Map priceMap = {
                            widget.product.product_prices.keys.first:
                                productDetailPageController.customPrice.value
                          };
                          print(priceMap);
                          Shopping shopping = Shopping(
                              product_id: widget.product.product_id,
                              product_name: widget.product.product_name,
                              product_image: widget.product.product_images[0],
                              product_price: priceMap,
                              product_color: widget.product.product_colors.keys
                                  .elementAt(productDetailPageController
                                      .colorIndex.value),
                              user_id: userData.id,
                              user_name: userData.name,
                              user_surname: userData.surname,
                              shopping_status: "Sipariş Alındı",
                              shopping_id: "0",
                              shopping_date: DateFormat("dd/MM/yyyy")
                                  .format(DateTime.now()),
                              shopping_count: "1",
                              additionalServices: productDetailPageController
                                  .cartAdditionalServicesList);
                          productDetailPageController.shoppingList
                              .add(shopping);
                          productDetailPageController.totalPriceFun();
                        }),
                    _buildElevatedButton(
                        text: "Sepete Ekle",
                        color: blue,
                        press: () {
                          productDetailPageController.cartAdditionalServices();
                          Map priceMap = {
                            widget.product.product_prices.keys.first:
                                productDetailPageController.customPrice.value
                          };
                          Shopping shopping = Shopping(
                              product_id: widget.product.product_id,
                              product_name: widget.product.product_name,
                              product_image: widget.product.product_images[0],
                              product_price: priceMap,
                              product_color: widget.product.product_colors.keys
                                  .elementAt(productDetailPageController
                                      .colorIndex.value),
                              user_id: userData.id,
                              user_name: userData.name,
                              user_surname: userData.surname,
                              shopping_status: "Sipariş Alındı",
                              shopping_id: "0",
                              shopping_date: DateFormat("dd/MM/yyyy")
                                  .format(DateTime.now()),
                              shopping_count: "1",
                              additionalServices: productDetailPageController
                                  .cartAdditionalServicesList);

                          productDetailPageController.shoppingList
                              .add(shopping);
                          productDetailPageController.totalPriceFun();
                        }),
                  ],
                ),
              );
            } else {
              return const Text("Veri Bulunamadı");
            }
          }),
    );
  }

  Widget _buildReviews(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 2.w),
      child: Column(
        children: [
          Text("Ürün Değerlendirmeleri",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          Row(
            children: [
              SizedBox(
                  height: 15.w,
                  width: 10.w,
                  child: Image.network(widget.product.product_images[0])),
              SizedBox(
                width: 10.w,
                child: Text(
                  productDetailPageController.starAverage.value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              for (int i = 1;
                  i <=
                      double.parse(
                          productDetailPageController.starAverage.value);
                  i++) ...[
                const Icon(
                  FontAwesomeIcons.solidStar,
                  color: orange,
                )
              ],
              if (double.parse(productDetailPageController.starAverage.value) -
                      double.parse(
                              productDetailPageController.starAverage.value)
                          .floor() !=
                  0.0) ...[
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Iconun tam görüntüsü
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 1),
                        width: (double.parse(productDetailPageController
                                    .starAverage.value) -
                                double.parse(productDetailPageController
                                        .starAverage.value)
                                    .floor()) *
                            25,
                        color: orange,
                      ),
                    ),
                    SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.asset("assets/images/yıldızIcon.png")),
                  ],
                ),
              ],
              const Spacer(),
              SizedBox(
                width: 20.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.product.product_reviews.length}",
                      textAlign: TextAlign.end,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    Text(
                      "değerlendirme",
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Colors.black54, fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
          if (widget.product.product_reviews.length != 0) ...[
            SizedBox(
                height: 35.h,
                child: ListView.builder(
                    itemCount: widget.product.product_reviews.length,
                    itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          height: 20.h,
                          decoration: BoxDecoration(
                              border: Border.all(color: gray),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 4.h,
                                    width: 4.h,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: Text(
                                          "${widget.product.product_reviews[index]["user_name"][0]}" +
                                              "${widget.product.product_reviews[index]["user_surname"][0]}"),
                                    ),
                                  ),
                                  Text(
                                      "${widget.product.product_reviews[index]["user_name"]} " +
                                          productDetailPageController.maskName(
                                              widget.product
                                                      .product_reviews[index]
                                                  ["user_surname"])),
                                  const Spacer(),
                                  Icon(
                                    FontAwesomeIcons.solidStar,
                                    color: Colors.orange,
                                    size: 16.sp,
                                  ),
                                  Text(
                                    widget.product.product_reviews[index]
                                        ["star"],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp),
                                  )
                                ],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(widget
                                    .product.product_reviews[index]["date"]),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    widget.product.product_reviews[index]
                                        ["comment"]),
                              )
                            ],
                          ),
                        ))),
          ],
          const Divider(),
          SizedBox(
            height: 2.h,
          )
        ],
      ),
    );
  }

  Widget _buildAdditionalServices(BuildContext context) {
    if (widget.product.additionalServices.length != 0) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ek Hizmetler",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
                width: 30.w,
                child: const Divider(
                  height: 5,
                )),
            SizedBox(
              height: 15.h,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.product.additionalServices.length,
                  itemBuilder: (context, index) {
                    final Map<dynamic, dynamic> additionalServicesCopy = {
                      "additionalService_name": widget.product
                          .additionalServices[index]["additionalService_name"],
                      "isSelect": false,
                      "additionalService_price": widget.product
                          .additionalServices[index]["additionalService_price"],
                    };
                    productDetailPageController.newAdditionalServicesList
                        .add(additionalServicesCopy);

                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                      height: 10.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Obx(() => IconButton(
                                  onPressed: () {
                                    productDetailPageController
                                        .updateNewAdditionalServicesList(index);
                                  },
                                  icon: Icon(
                                    productDetailPageController
                                                    .newAdditionalServicesList[
                                                index]["isSelect"] ==
                                            true
                                        ? Icons.check_circle
                                        : FontAwesomeIcons.circle,
                                    size: 17.sp,
                                  ))),
                              Text(
                                widget.product.additionalServices[index]
                                    ["additionalService_name"],
                                style: const TextStyle(
                                    color: blue, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.product.additionalServices[index]
                                    ["additionalService_description"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${widget.product.additionalServices[index]["additionalService_price"]} TL",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const Spacer(),
                          const Divider(),
                          Row(
                            children: [
                              Container(
                                  height: 4,
                                  width: 4,
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle)),
                              Text(
                                widget.product.additionalServices[index]
                                    ["additionalService_firstAtribute"],
                                style: TextStyle(fontSize: 13.sp),
                              ),
                              const Spacer(),
                              Container(
                                  height: 4,
                                  width: 4,
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle)),
                              Text(
                                widget.product.additionalServices[index]
                                    ["additionalService_secondAtribute"],
                                style: TextStyle(fontSize: 13.sp),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildPrices(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Fiyat",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(
              width: 30.w,
              child: const Divider(
                height: 5,
              )),
          SizedBox(
            height: 9.h,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.product.product_prices.length,
                itemBuilder: (context, index) {
                  String key =
                      widget.product.product_prices.keys.elementAt(index);

                  return Obx(() => GestureDetector(
                        onTap: () {
                          productDetailPageController.updatePriceIndex(index);
                          for (int i = 0;
                              i < widget.product.additionalServices.length;
                              i++) {
                            productDetailPageController
                                    .newAdditionalServicesList[i]["isSelect"] =
                                false;
                            productDetailPageController
                                    .newAdditionalServicesList[i] =
                                Map<String, dynamic>.from(
                                    productDetailPageController
                                        .newAdditionalServicesList[i]);
                          }

                          productDetailPageController.updateCustomPrice(
                              widget.product.product_prices[key]);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 1.w),
                          height: 8.h,
                          width: 30.w,
                          decoration: BoxDecoration(
                              border: productDetailPageController.priceIndex ==
                                      index
                                  ? Border.all(color: Colors.black, width: 2)
                                  : Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                key,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "${productDetailPageController.changeFormatPrice(int.parse(widget.product.product_prices[key]))} TL",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ));
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.product.product_desTitle,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          Text(widget.product.product_desDetail,
              style:
                  Theme.of(context).textTheme.bodyMedium!.copyWith(height: 1.6))
        ],
      ),
    );
  }

  Column _buildColors(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Renkler",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
            width: 30.w,
            child: const Divider(
              height: 5,
            )),
        SizedBox(
          height: 12.h,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.product.product_colors.length,
              itemBuilder: (context, index) {
                final colorName =
                    widget.product.product_colors.keys.elementAt(index);

                return GestureDetector(
                  onTap: () {
                    productDetailPageController.updateColorIndex(index);
                  },
                  child: Column(
                    children: [
                      Obx(() => Container(
                            padding: const EdgeInsets.all(3),
                            margin: EdgeInsets.only(
                                left: 0.5.w,
                                right: 0.5.w,
                                top: 1.h,
                                bottom: 0.2.h),
                            height: 5.h,
                            width: 5.h,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: productDetailPageController
                                                .colorIndex.value ==
                                            index
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2)),
                            child: DecoratedBox(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey),
                                    color: Color(int.parse(
                                        '0xFF${widget.product.product_colors[colorName]}')))),
                          )),
                      SizedBox(
                        width: 7.w,
                        child: const Divider(
                          thickness: 1,
                          height: 5,
                        ),
                      ),
                      SizedBox(
                        width: 5.h,
                        child: Center(
                          child: Text(
                            colorName,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }

  SizedBox _buildImage() {
    return SizedBox(
      height: 30.h,
      child: Hero(
        tag: widget.product.product_images[0],
        child: PageView.builder(
            itemCount: widget.product.product_images.length,
            itemBuilder: (context, index) =>
                Image.network(widget.product.product_images[index])),
      ),
    );
  }

  SizedBox _buildElevatedButton(
      {required String text, required Function press, required Color color}) {
    return SizedBox(
      width: 30.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            onPressed: () {
              press();
            },
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
