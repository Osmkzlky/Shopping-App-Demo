// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:shopping_app_demo/controllers/customCardController.dart';
import 'package:shopping_app_demo/helpers/size.dart';
import 'package:shopping_app_demo/models/Product.dart';
import 'package:shopping_app_demo/models/UserData.dart';
import 'package:shopping_app_demo/services/auth.dart';
import 'package:shopping_app_demo/views/productDetailPage.dart';

class CustomCard extends StatefulWidget {
  final Product product;
  final String formatPrice;

  CustomCard({
    Key? key,
    required this.product,
    required this.formatPrice,
  }) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  final customCardController = Get.put(CustomCardController());
  @override
  void initState() {
    customCardController.starAverage.value = "0.0";
    customCardController.starAverageFun(widget.product.product_reviews);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String star = customCardController.starAverage.value;

    return SizedBox(
      height: 20.h,
      width: 45.w,
      child: GestureDetector(
          onTap: () {
            // kodu tekrarlama sebebimiz onTap sadece tıkladığımızda çalışıyor.
            // Bu yüzden fonksiyonu tekrar çalıştırıp doğru veriyi gönderiyoruz.
            customCardController.starAverage.value = "0.0";
            customCardController.starAverageFun(widget.product.product_reviews);
            Get.to(ProductDetailPage(
              product: widget.product,
            ));
          },
          child: StreamBuilder<UserData?>(
              stream: Auth().getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  UserData userData = snapshot.data!;
                  for (int i = 0; i < userData.favoriteProductIds.length; i++) {
                    customCardController.isSaved.value = false;

                    if (widget.product.product_id ==
                        userData.favoriteProductIds[i]) {
                      customCardController.isSaved.value = true;
                      break;
                    }
                  }
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: 13.h,
                              width: 40.w,
                              child: PageView.builder(
                                itemCount: widget.product.product_images.length,
                                itemBuilder: (context, index) => SizedBox(
                                    height: 13.h,
                                    child: Image.network(
                                        widget.product.product_images[index])),
                              )),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  maxLines: 2,
                                  widget.product.product_name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    if (customCardController.isSaved.value) {
                                      customCardController.isSaved.value =
                                          false;
                                    } else {
                                      customCardController.isSaved.value = true;
                                    }
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
                                          color: Colors.orange,
                                        )
                                      : const FaIcon(FontAwesomeIcons.bookmark))
                            ],
                          ),
                          Text(
                            "${widget.formatPrice} TL",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.solidStar,
                                size: 13.sp,
                                color: Colors.orange,
                              ),
                              Text(
                                star,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.sp),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Text("Veri Bulunamadı");
                }
              })),
    );
  }
}
