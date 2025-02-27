import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shopping_app_demo/components/customCard.dart';
import 'package:shopping_app_demo/controllers/customCardController.dart';
import 'package:shopping_app_demo/controllers/productDetailPageController.dart';
import 'package:shopping_app_demo/controllers/searchPageController.dart';
import 'package:shopping_app_demo/helpers/size.dart';
import 'package:shopping_app_demo/models/Product.dart';
import 'package:shopping_app_demo/theme/colors.dart';
import 'package:shopping_app_demo/views/productDetailPage.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final customCardController = Get.put(CustomCardController());
  final productDetailPageController = Get.put(ProductDetailPageController());
  final searchPageController = Get.put(SearchPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Arama'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Column(
            children: [
              TextField(
                controller: searchPageController.searchController,
                decoration: const InputDecoration(
                  hintText: 'Ürün ara...',
                  prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchPageController.searchController.text =
                        value.toLowerCase();
                  });
                },
              ),
              SizedBox(
                height: 90.h,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('productList')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Bir hata oluştu: ${snapshot.error}'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var filteredDocs = snapshot.data!.docs.where((doc) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      String productName =
                          data['product_name']?.toString().toLowerCase() ?? '';
                      return productName
                          .contains(searchPageController.searchController.text);
                    }).toList();

                    if (filteredDocs.isEmpty) {
                      return const Center(child: Text('Ürün bulunamadı'));
                    }

                    return Column(
                      children: [
                        if (searchPageController.searchController.text ==
                            "") ...[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Geçmiş Aramalarım"),
                                    GestureDetector(
                                      onTap: () {
                                        productDetailPageController
                                            .lastSearchList.value = [];
                                      },
                                      child: const Text(
                                        "Tümünü Sil",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    )
                                  ],
                                ),
                                const Divider(),
                                SizedBox(
                                    height: 30.h,
                                    child: Obx(
                                      () => ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: productDetailPageController
                                              .lastSearchList.length,
                                          itemBuilder: (context, index) {
                                            Product product =
                                                productDetailPageController
                                                    .lastSearchList[index];

                                            return Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      productDetailPageController
                                                          .deleteSearch(index);
                                                    },
                                                    icon: FaIcon(
                                                      FontAwesomeIcons.xmark,
                                                      size: 15.sp,
                                                    )),
                                                Text(
                                                  product.product_name,
                                                  style:
                                                      TextStyle(color: black),
                                                ),
                                              ],
                                            );
                                          }),
                                    )),
                                const Text("En Son Gezdiklerim"),
                                const Divider(),
                                SizedBox(
                                  height: 25.h,
                                  child: ListView.builder(
                                      itemCount: productDetailPageController
                                          .lastVisitedList.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        List products = filteredDocs
                                            .map((doc) => Product.fromJson(
                                                doc.data()
                                                    as Map<String, dynamic>))
                                            .toList();
                                        Product product = products[int.parse(
                                            productDetailPageController
                                                .lastVisitedList[index])];
                                        return CustomCard(
                                            product: product,
                                            formatPrice: product
                                                .product_prices.values.first);
                                      }),
                                )
                              ],
                            ),
                          )
                        ] else ...[
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredDocs.length,
                              itemBuilder: (context, index) {
                                Product product = Product.fromJson(
                                    filteredDocs[index].data()
                                        as Map<String, dynamic>);

                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                    onTap: () async {
                                      productDetailPageController
                                          .addLastSearchList(product);
                                      Get.to(ProductDetailPage(
                                        product: product,
                                      ));
                                    },
                                    child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 3.w),
                                        height: 5.h,
                                        decoration: BoxDecoration(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("﹒"),
                                            Text(
                                              product.product_name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: black),
                                            ),
                                            const Spacer(),
                                            const Icon(
                                              Icons.north_west,
                                              color: blue,
                                            )
                                          ],
                                        )),
                                  ),
                                );
                              },
                            ),
                          ),
                        ]
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
