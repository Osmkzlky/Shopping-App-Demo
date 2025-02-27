import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app_demo/controllers/loginPageController.dart';
import 'package:shopping_app_demo/helpers/size.dart';
import 'package:shopping_app_demo/services/auth.dart';
import 'package:shopping_app_demo/theme/colors.dart';

class ForgetPasswordPage extends StatelessWidget {
  final loginPageController = Get.put(LoginPageController());

  ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Şifremi Unuttum",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: SizedBox(
                height: 30.h,
                child: LottieBuilder.asset(
                    "assets/animations/forgetAnimation.json")),
          ),
          const Text(
            "Şifrenizi resetlemek için email adresinizi giriniz:",
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: blue, width: 2),
                  boxShadow: const [
                    BoxShadow(color: blue, offset: Offset(2, 2))
                  ],
                  borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: loginPageController.forgetPassController,
                  decoration: const InputDecoration(
                      border: InputBorder.none, labelText: "Email"),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5.h,
            width: 60.w,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: blue,
                    side: const BorderSide(color: black, width: 1)),
                onPressed: () {
                  Auth().sendPasswordResetLink(
                      email: loginPageController.forgetPassController.text);
                },
                child: const Text(
                  "Gönder",
                  style: TextStyle(color: white),
                )),
          ),
        ],
      ),
    );
  }
}
