// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app_demo/components/customCard.dart';
import 'package:shopping_app_demo/controllers/homePageController.dart';
import 'package:shopping_app_demo/helpers/size.dart';
import 'package:shopping_app_demo/models/BannerData.dart';
import 'package:shopping_app_demo/models/Category.dart';
import 'package:shopping_app_demo/models/Product.dart';
import 'package:shopping_app_demo/models/Story.dart';
import 'package:shopping_app_demo/services/firebase_services.dart';
import 'package:shopping_app_demo/theme/colors.dart';
import 'package:shopping_app_demo/views/advertisementsPage.dart';
import 'package:shopping_app_demo/views/productListPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homePageController = Get.put(HomePageController());
  @override
  void initState() {
    FirebaseServices().getAllProducts();
    FirebaseServices().getStories();
    FirebaseServices().getBanners();
    homePageController.bannerAnimation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildStories(),
            _buildBanner(),
            FutureBuilder<List<Category>>(
                future: FirebaseServices().getCategory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    List<Category> categoryList = snapshot.data!;

                    return SizedBox(
                      height: 33.h * categoryList.length,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: categoryList.length,
                          itemBuilder: (context, index) {
                            Category category = categoryList[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 1.h),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(category.category_name),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(ProductListPage(
                                              product_ids: category.product_ids,
                                              title: category.category_name));
                                        },
                                        child: const Text(
                                          "Tümü",
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 27.h,
                                    child: FutureBuilder<Products>(
                                        future:
                                            FirebaseServices().getAllProducts(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          if (snapshot.hasData) {
                                            Products products = snapshot.data!;

                                            return ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    category.product_ids.length,
                                                itemBuilder: (context, index2) {
                                                  Product product = products
                                                          .products[
                                                      int.parse(
                                                          category.product_ids[
                                                              index2])];

                                                  final formatPrice =
                                                      NumberFormat.currency(
                                                              locale: "tr_TR",
                                                              symbol: "",
                                                              decimalDigits: 0)
                                                          .format(int.parse(
                                                              product
                                                                  .product_prices
                                                                  .values
                                                                  .first));

                                                  return CustomCard(
                                                      product: product,
                                                      formatPrice: formatPrice);
                                                });
                                          } else {
                                            return const Text("Veri Yok");
                                          }
                                        }),
                                  )
                                ],
                              ),
                            );
                          }),
                    );
                  } else {
                    return const Text("Veri Yok");
                  }
                })
          ],
        ),
      ),
    );
  }

  SizedBox _buildBanner() {
    return SizedBox(
      height: 25.h,
      child: StreamBuilder<List<BannerData>>(
          stream: FirebaseServices().getBanners(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              List<BannerData> banners = snapshot.data!;
              // Listenin sonuna geldiğinde başa dönmemiz için listenin boyutunu numberOfBanner a atıyoruz
              homePageController.numberOfBanner = banners.length;
              return GestureDetector(
                onTap: () {
                  Get.to(ProductListPage(
                      product_ids: banners[homePageController.bannerPageIndex]
                          .product_ids,
                      title: banners[homePageController.bannerPageIndex]
                          .banner_name));
                },
                child: PageView.builder(
                    controller: homePageController.pageController,
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      homePageController.bannerPageIndex = index;
                      BannerData bannerData = banners[index];

                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            bannerData.banner_image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return const Text("Veri Bulunamadı");
            }
          }),
    );
  }

  SizedBox _buildStories() {
    return SizedBox(
      height: 8.h,
      child: StreamBuilder<List<Story>>(
          stream: FirebaseServices().getStories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              List<Story> stories = snapshot.data!;
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    Story story = stories[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(AdvertisementsPage(
                          stories: stories,
                          index: index,
                        ));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        height: 8.h,
                        width: 7.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2),
                            shape: BoxShape.circle),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.w, vertical: 1.h),
                          child: ClipOval(
                              child: Image.network(
                            story.story_image,
                            fit: BoxFit.cover,
                          )),
                        ),
                      ),
                    );
                  });
            } else {
              return const Text("Veri Bulunamadı");
            }
          }),
    );
  }
}
