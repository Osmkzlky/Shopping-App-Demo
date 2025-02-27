// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shopping_app_demo/controllers/addressesController.dart';
import 'package:shopping_app_demo/helpers/size.dart';
import 'package:shopping_app_demo/models/UserData.dart';
import 'package:shopping_app_demo/services/auth.dart';
import 'package:shopping_app_demo/theme/colors.dart';
import 'package:shopping_app_demo/views/addAddressPage.dart';

class AddorUpdateAddressesPage extends StatelessWidget {
  final addressesController = Get.put(AddressesController());

  AddorUpdateAddressesPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adreslerim"),
      ),
      body: StreamBuilder<UserData?>(
          stream: Auth().getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasData) {
              UserData userData = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      addressesController.nameController.text = "";
                      addressesController.surnameContorller.text = "";
                      addressesController.phoneContorller.text = "";
                      addressesController.buildTypeController.text = "";
                      addressesController.cityContoller.text = "";
                      addressesController.districtController.text = "";
                      addressesController.addressNameController.text = "";
                      Get.to(AddAddressPage(
                        buttonSaveText: "Adresi Kaydet",
                        buttonSavePress: () {
                          addressesController.addAddress();
                          Get.back();
                        },
                        buttonDeleteText: "Vazgeç",
                        buttonDeletePress: () {
                          Get.back();
                        },
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      height: 5.h,
                      width: 35.w,
                      decoration: BoxDecoration(
                          border: Border.all(color: orange, width: 2),
                          borderRadius: BorderRadius.circular(7)),
                      child: const Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.circlePlus,
                            color: orange,
                          ),
                          Text(
                            "Adres Ekle",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50.h,
                    child: ListView.builder(
                        itemCount: userData.addresses.length,
                        itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 1.h),
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              height: 10.h,
                              decoration: BoxDecoration(
                                  border: Border.all(color: blue, width: 2),
                                  borderRadius: BorderRadius.circular(7)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.house,
                                            color: blue,
                                            size: 16.sp,
                                          ),
                                          Text(
                                            userData.addresses[index]
                                                ["address_title"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.sp),
                                          ),
                                        ],
                                      ),
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(color: black),
                                              children: [
                                            TextSpan(
                                                text:
                                                    "${userData.addresses[index]["address_name"]}\n"),
                                            TextSpan(
                                                text:
                                                    "${userData.addresses[index]["address_neighborhood"]} "),
                                            TextSpan(
                                                text:
                                                    "${userData.addresses[index]["address_district"]}\\"),
                                            TextSpan(
                                                text: userData.addresses[index]
                                                    ["address_city"]),
                                          ]))
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        addressesController
                                                .nameController.text =
                                            userData.addresses[index]
                                                ["address_userName"];
                                        addressesController
                                                .surnameContorller.text =
                                            userData.addresses[index]
                                                ["address_userSurname"];
                                        addressesController
                                                .phoneContorller.text =
                                            userData.addresses[index]
                                                ["address_userPhone"];
                                        addressesController
                                                .buildTypeController.text =
                                            userData.addresses[index]
                                                ["address_name"];
                                        addressesController.cityContoller.text =
                                            userData.addresses[index]
                                                ["address_city"];
                                        addressesController
                                                .districtController.text =
                                            userData.addresses[index]
                                                ["address_district"];
                                        addressesController
                                                .neighborhoodController.text =
                                            userData.addresses[index]
                                                ["address_neighborhood"];
                                        addressesController
                                                .addressNameController.text =
                                            userData.addresses[index]
                                                ["address_title"];
                                        Get.to(AddAddressPage(
                                          buttonSaveText: "Adresi Güncelle",
                                          buttonSavePress: () async {
                                            addressesController
                                                .updateAddress(index);
                                            Get.back();
                                          },
                                          buttonDeleteText: "Adresi Sil",
                                          buttonDeletePress: () {
                                            Auth().deleteAddressAtIndex(index);
                                            Get.back();
                                          },
                                        ));
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.solidPenToSquare,
                                        color: blue,
                                      ))
                                ],
                              ),
                            )),
                  )
                ],
              );
            } else {
              return const Text("Veri Bulunamadı");
            }
          }),
    );
  }
}
