// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shopping_app_demo/helpers/size.dart';

import 'package:shopping_app_demo/models/UserData.dart';
import 'package:shopping_app_demo/theme/colors.dart';

class CustomerServicesPage extends StatelessWidget {
  final UserData userData;
  const CustomerServicesPage({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text("tek0\$",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: blue, fontSize: 20.sp)),
            Text(
              "Merhaba ${userData.name} ${userData.surname}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("Hangi konuda desteğe ihtiyacınız var?"),
            SizedBox(
              height: 20.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildContainer(
                      iconData: FontAwesomeIcons.truck,
                      text: "Teslimat ve kargo"),
                  _buildContainer(
                      iconData: FontAwesomeIcons.truckRampBox,
                      text: "İptal / İade ve Diğer Talepler"),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    border: Border.all(color: black),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: const TextField(
                    decoration: InputDecoration(
                        hintText: "Hangi konuda desteğe ihtiyacınız var",
                        border: InputBorder.none),
                  ),
                ),
              ),
            ),
            SizedBox(
                width: 90.w,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(side: BorderSide(color: blue)),
                    onPressed: () {},
                    child: Text(
                      "Gönder",
                      style:
                          TextStyle(color: blue, fontWeight: FontWeight.bold),
                    )))
          ]),
        ),
      ),
    );
  }

  Container _buildContainer({
    required IconData iconData,
    required String text,
  }) {
    return Container(
      height: 20.h,
      width: 45.w,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      decoration:
          BoxDecoration(color: blue, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: white,
          ),
          Text(
            text,
            style: TextStyle(color: white, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
