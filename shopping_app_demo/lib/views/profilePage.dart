// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app_demo/controllers/profilePageController.dart';
import 'package:shopping_app_demo/helpers/size.dart';

import 'package:shopping_app_demo/models/UserData.dart';
import 'package:shopping_app_demo/services/auth.dart';
import 'package:shopping_app_demo/theme/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profilePageController = Get.put(ProfilePageController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<UserData?>(
              stream: Auth().getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  UserData userData = snapshot.data!;
                  profilePageController.emailController.text = userData.email;
                  profilePageController.nameController.text = userData.name;
                  profilePageController.surnameController.text =
                      userData.surname;
                  profilePageController.phoneController.text = userData.phone;
                  profilePageController.genderIndex.value =
                      int.parse(userData.gender);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back_ios)),
                      _buildUpdateProfile(),
                      _buildContactInformation(),
                      _buildPassword()
                    ],
                  );
                } else {
                  return Text("Veri Bulunamadı");
                }
              }),
        ),
      ),
    );
  }

  Widget _buildUpdateProfile() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      height: 40.h,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profil Bilgileri",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          Text(
            "tek0\$ deneyiminizi en iyi seviyede tutuabilmemiz için gereken bilgilerinizi buradan düzenleyebilirsiniz",
            style: TextStyle(fontSize: 15.sp),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: _buildTextField(
                      text: "Ad:",
                      controller: profilePageController.nameController)),
              Expanded(
                  child: _buildTextField(
                      text: "Soyad:",
                      controller: profilePageController.surnameController)),
            ],
          ),
          Text(
            "Cinsiyet:",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGender(
                  key: 0,
                  text: "Kadın",
                  press: () {
                    profilePageController.updateGenderIndex(0);
                  }),
              _buildGender(
                  key: 1,
                  text: "Erkek",
                  press: () {
                    profilePageController.updateGenderIndex(1);
                  }),
              _buildGender(
                  key: 2,
                  text: "Belirtilmemiş",
                  press: () {
                    profilePageController.updateGenderIndex(2);
                  }),
            ],
          ),
          _buildElevatedButton(press: () async {
            await Auth().updateNameSurnameGender(
                name: profilePageController.nameController.text,
                surname: profilePageController.surnameController.text,
                gender: profilePageController.genderIndex.value.toString());
            Get.back();
          })
        ],
      ),
    );
  }

  Widget _buildContactInformation() {
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "İletişim Bilgileri",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          Text(
            "Bu bilgileri değiştirmek için yeni e-posta adresinizi veya telefon numaranızı doğrulamanızı isteyeceğiz.",
            style: TextStyle(fontSize: 15.sp),
          ),
          _buildTextField(
              keyboardType: TextInputType.phone,
              text: "Cep Telefon Numarası",
              controller: profilePageController.phoneController),
          _buildTextField(
              text: "E-posta Adresi",
              controller: profilePageController.emailController),
          _buildElevatedButton(press: () {
            Auth().updatePhoneEmail(
                email: profilePageController.emailController.text,
                phone: profilePageController.phoneController.text);
            Get.back();
          })
        ],
      ),
    );
  }

  Widget _buildPassword() {
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Şifre Bilgileri",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          Text(
              "Şifreniz en az bir harf, rakam veya özel karakter içermeli. Ayrıca şifreniniz en az 8 karakterden oluşmalı"),
          //_buildTextField(text: "Mevcut Şifreniz:"),
          // _buildTextField(text: "Yeni Şifreniz:"),
          _buildElevatedButton(press: () {})
        ],
      ),
    );
  }

  Widget _buildElevatedButton({required Function press}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onPressed: () {
            press();
          },
          child: const Text(
            "Güncelle",
            style: TextStyle(color: blue, fontWeight: FontWeight.bold),
          )),
    );
  }

  Widget _buildGender(
      {required String text, required Function press, required int key}) {
    return GestureDetector(
      onTap: () {
        press();
      },
      child: Obx(() => Row(
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                    color: profilePageController.genderIndex.value == key
                        ? blue
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: gray)),
              ),
              Text(text),
            ],
          )),
    );
  }

  Widget _buildTextField(
      {required String text,
      required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: gray, width: 2),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: TextField(
            keyboardType: keyboardType,
            controller: controller,
            style: TextStyle(fontSize: 15.sp),
            decoration:
                InputDecoration(border: InputBorder.none, labelText: text),
          ),
        ),
      ),
    );
  }
}
