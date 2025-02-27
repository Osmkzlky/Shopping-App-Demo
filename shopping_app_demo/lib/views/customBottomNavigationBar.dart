import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shopping_app_demo/controllers/customBottomNavigationBarController.dart';
import 'package:shopping_app_demo/helpers/size.dart';
import 'package:shopping_app_demo/models/UserData.dart';
import 'package:shopping_app_demo/services/auth.dart';
import 'package:shopping_app_demo/theme/colors.dart';
import 'package:shopping_app_demo/views/accountPage.dart';
import 'package:shopping_app_demo/views/cartPage.dart';
import 'package:shopping_app_demo/views/favoriteProductsPage.dart';
import 'package:shopping_app_demo/views/homePage.dart';
import 'package:shopping_app_demo/views/productCategoryPage.dart';
import 'package:shopping_app_demo/views/searchPage.dart';
import 'package:shopping_app_demo/views/settingPage.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final customBottomNavigationBarController =
      Get.put(CustomBottomNavigationBarController());
  CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "tekO\$",
            style: TextStyle(fontWeight: FontWeight.bold, color: blue),
          ),
          leading: StreamBuilder<UserData?>(
              stream: Auth().getUserData(),
              builder: (context, snapshot) {
                return IconButton(
                    onPressed: () {
                      Get.to(SearchPage());
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: blue,
                    ));
              }),
          actions: [
            StreamBuilder<UserData?>(
                stream: Auth().getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    UserData userData = snapshot.data!;
                    return GestureDetector(
                      onTap: () {
                        Get.to(const SettingPage());
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.5.w),
                        height: 4.h,
                        width: 4.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: blue, width: 2),
                            shape: BoxShape.circle),
                        child: Center(
                            child: Text(
                          userData.name[0] + userData.surname[0],
                          style: TextStyle(
                              color: blue, fontWeight: FontWeight.bold),
                        )),
                      ),
                    );
                  } else {
                    return const Text("Veri Bulunamadı");
                  }
                })
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 75,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: customBottomNavigationBarController
                  .bottomNavContent.entries
                  .map((entry) {
                int index = customBottomNavigationBarController
                    .bottomNavContent.keys
                    .toList()
                    .indexOf(entry.key);

                return TextButton(
                    onPressed: () {
                      customBottomNavigationBarController
                          .updateBottomIndex(index);
                    },
                    child: Obx(() => Column(
                          children: [
                            Icon(
                              entry.value,
                              color: index ==
                                      customBottomNavigationBarController
                                          .bottomIndex.value
                                  ? blue
                                  : Colors.grey,
                            ),
                            Text(
                              entry.key,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: index ==
                                          customBottomNavigationBarController
                                              .bottomIndex.value
                                      ? Colors.black
                                      : Colors.grey),
                            )
                          ],
                        )));
              }).toList()),
        ),
        body: StreamBuilder<UserData?>(
            stream: Auth().getUserData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserData userData = snapshot.data!;
                List<Widget> bodyList = [
                  const HomePage(),
                  ProductCategoryPage(userData: userData),
                  CartPage(),
                  FavoriteProductsPage(userData: userData),
                  AccountPage(
                    userData: userData,
                  )
                ];

                return Obx(() => bodyList[
                    customBottomNavigationBarController.bottomIndex.value]);
              } else {
                return const Text("Veri Bulunamadı");
              }
            }));
  }
}
