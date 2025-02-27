import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app_demo/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app_demo/views/customBottomNavigationBar.dart';

class LoginPageController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isCheck = false.obs;
  void updateCheck() {
    isCheck.value = !isCheck.value;
  }

  final formkey = GlobalKey<FormState>();
  @override
  void onInit() async {
    final prefs = await SharedPreferences.getInstance();
    isCheck.value = prefs.getBool("rememberMe") ?? false;
    if (isCheck.value) {
      emailController.text = prefs.getString("email") ?? "";
      passwordController.text = prefs.getString("password") ?? "";
    }
    super.onInit();
  }

  Future<void> signIn(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      final result = await Auth().sigIn(
          email: emailController.text, password: passwordController.text);
      if (result == "success") {
        Future.delayed(const Duration(microseconds: 500))
            .then((value) => Get.to(CustomBottomNavigationBar()));
        saveUserToDevice();
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text("Hata"),
              content: Text(result ?? " "),
            );
          },
        );
      }
    }
  }

  void rememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("rememberMe", isCheck.value);
    print(prefs.getBool("rememberMe"));
  }

  void saveUserToDevice() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("rememberMe") == true) {
      prefs.setString("email", emailController.text);
      prefs.setString("password", passwordController.text);
      print("mail ve şifre cihaz hafızasında");
    } else {
      print("cihaz kayıt hatası");
    }
  }

  TextEditingController forgetPassController = TextEditingController();
}
