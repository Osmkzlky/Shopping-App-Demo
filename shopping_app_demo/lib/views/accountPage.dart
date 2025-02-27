// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shopping_app_demo/controllers/customBottomNavigationBarController.dart';
import 'package:shopping_app_demo/helpers/size.dart';
import 'package:shopping_app_demo/models/UserData.dart';
import 'package:shopping_app_demo/theme/colors.dart';
import 'package:shopping_app_demo/views/addressPage.dart';
import 'package:shopping_app_demo/views/customerServices.dart';
import 'package:shopping_app_demo/views/ordersPage.dart';
import 'package:shopping_app_demo/views/settingPage.dart';

class AccountPage extends StatelessWidget {
  final customBottomNavigationBarController =
      Get.put(CustomBottomNavigationBarController());
  final UserData userData;
  AccountPage({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        _builldInfoContainer(userData: userData),
        _buildCustomButton(
            text: "Siparişlerim",
            icon: FontAwesomeIcons.box,
            press: () {
              Get.to(OrdersPage(userId: userData.id));
            }),
        _buildCustomButton(
            text: "Adreslerim",
            icon: FontAwesomeIcons.mapLocationDot,
            press: () {
              Get.to(AddorUpdateAddressesPage());
            }),
        _buildCustomButton(
            text: "Sorular ve Taleplerim",
            icon: FontAwesomeIcons.question,
            press: () {}),
        _buildCustomButton(
            text: "Favorilerim",
            icon: FontAwesomeIcons.solidBookmark,
            press: () {
              customBottomNavigationBarController.bottomIndex.value = 3;
            }),
        _buildCustomButton(
            text: "Ayarlarım",
            icon: FontAwesomeIcons.gear,
            press: () {
              Get.to(const SettingPage());
            }),
        _buildCustomButton(
            text: "Müşteri Hizmetleri",
            icon: FontAwesomeIcons.headset,
            press: () {
              Get.to(CustomerServicesPage(userData: userData));
            }),
        SizedBox(
            height: 5.h,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: TextButton(
                  style: TextButton.styleFrom(
                      side: const BorderSide(color: gray),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    // Auth().sigOut();
                    //Get.to(LoginPage());
                  },
                  child: Text(
                    "Çıkış Yap",
                    style: TextStyle(
                        color: blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp),
                  )),
            ))
      ],
    ));
  }

  Widget _builldInfoContainer({required UserData userData}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 6.h,
          width: 6.h,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.3),
              shape: BoxShape.circle),
          child: Center(
              child: Text(
            userData.name[0] + userData.surname[0],
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          )),
        ),
        Text(
            "${userData.name.toUpperCase()} " +
                "${userData.surname.toUpperCase()}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp)),
        Divider(),
      ],
    );
  }

  TextButton _buildCustomButton(
          {required String text,
          required Function press,
          required IconData icon}) =>
      TextButton(
          style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5)),
          onPressed: () {
            press();
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon),
                Text(
                  text,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
                const Icon(Icons.arrow_right_sharp)
              ],
            ),
          ));
}
