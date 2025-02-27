// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shopping_app_demo/helpers/size.dart';
import 'package:shopping_app_demo/theme/colors.dart';
import 'package:shopping_app_demo/views/profilePage.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayarlarım"),
      ),
      body: Column(
        children: [
          _buildButton(
              text: "Üyelik Bilgisi Güncelleme",
              press: () {
                Get.to(ProfilePage());
              }),
          _buildButton(text: "Kayıtlı Kartlarım", press: () {}),
          _buildButton(text: "Alışveriş Rehberi", press: () {}),
          _buildButton(text: "Uygulama Hakkında", press: () {}),
        ],
      ),
    );
  }

  Widget _buildButton({required String text, required Function press}) {
    return SizedBox(
      height: 10.h,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            onPressed: () {
              press();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: white),
                ),
                const Icon(Icons.arrow_right, color: white)
              ],
            )),
      ),
    );
  }
}
