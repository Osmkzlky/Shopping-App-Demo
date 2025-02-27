// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shopping_app_demo/controllers/addressesController.dart';
import 'package:shopping_app_demo/helpers/size.dart';
import 'package:shopping_app_demo/theme/colors.dart';

class AddAddressPage extends StatefulWidget {
  final String buttonSaveText;
  final Function buttonSavePress;
  final String buttonDeleteText;
  final Function buttonDeletePress;
  AddAddressPage({
    Key? key,
    required this.buttonSaveText,
    required this.buttonSavePress,
    required this.buttonDeleteText,
    required this.buttonDeletePress,
  }) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final addressesController = Get.put(AddressesController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: SingleChildScrollView(
            child: Form(
              key: addressesController.formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Kişisel Bilgileriniz",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blue,
                            fontSize: 17.sp),
                      ),
                      const Expanded(child: Divider())
                    ],
                  ),
                  const Text("Teslim alacak kişinin bilgileri"),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                            hintText: "Ad",
                            controller: addressesController.nameController),
                      ),
                      Expanded(
                        child: _buildTextField(
                            hintText: "Soyad",
                            controller: addressesController.surnameContorller),
                      ),
                    ],
                  ),
                  const Text("Telefon"),
                  _buildTextField(
                      hintText: "Telefon",
                      controller: addressesController.phoneContorller),
                  Row(
                    children: [
                      Text(
                        "Adres Bilgilerim",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blue,
                            fontSize: 17.sp),
                      ),
                      const Expanded(child: Divider())
                    ],
                  ),
                  _buildTextField(
                      hintText: "Bina,site,iş yeri,kurum ismi vb",
                      controller: addressesController.buildTypeController),
                  _buildTextField(
                      hintText: "Şehir",
                      controller: addressesController.cityContoller),
                  _buildTextField(
                      hintText: "İlçe",
                      controller: addressesController.districtController),
                  _buildTextField(
                      hintText: "Mahalle",
                      controller: addressesController.neighborhoodController),
                  const Text("Bu adrese bir ad verin"),
                  _buildTextField(
                      hintText: "Örnek: Evim,İşim",
                      controller: addressesController.addressNameController),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx((() => Container(
                            margin: EdgeInsets.symmetric(horizontal: 2.w),
                            padding: const EdgeInsets.all(1),
                            height: 2.h,
                            width: 2.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: black),
                                borderRadius: BorderRadius.circular(7)),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: addressesController.isSelect.value
                                      ? blue
                                      : Colors.white),
                              child: addressesController.isSelect.value
                                  ? Icon(
                                      FontAwesomeIcons.check,
                                      color: white,
                                      size: 12.sp,
                                    )
                                  : null,
                            ),
                          ))),
                      SizedBox(
                        width: 86.w,
                        child: GestureDetector(
                          onTap: () => addressesController.changeSelect(),
                          child: RichText(
                              text: const TextSpan(children: [
                            TextSpan(
                                text: "Bu adresi fatura bilgilerinde kullan\n",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: black)),
                            TextSpan(
                                text:
                                    "Fatura için seçilen adres bilgi amaçlıdır. Ürünlerimiz \"Teslimat Adresi\" bölümünde seçtiğiniz adrese teslim edilir",
                                style: TextStyle(color: Colors.black45)),
                          ])),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(
                          text: widget.buttonDeleteText,
                          press: () {
                            widget.buttonDeletePress();
                          },
                          isSave: false),
                      _buildButton(
                          text: widget.buttonSaveText,
                          press: () {
                            widget.buttonSavePress();
                          },
                          isSave: true),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isObscureText = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: gray, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: TextFormField(
            controller: controller,
            validator: (value) {
              if (value!.isEmpty) {
                return "Bilgilerinizi Eksizsiz Giriniz";
              } else {
                return null;
              }
            },
            onSaved: (newValue) {
              controller.text = newValue!;
            },
            textInputAction: TextInputAction.next,
            obscureText: isObscureText,
            decoration: InputDecoration(
                labelText: hintText,
                labelStyle: TextStyle(fontSize: 15.sp),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      {required String text, required Function press, required bool isSave}) {
    return SizedBox(
      height: 10.h,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: isSave ? blue : white,
                side: const BorderSide(color: blue, width: 2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            onPressed: () {
              press();
            },
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isSave ? white : black),
            )),
      ),
    );
  }
}
