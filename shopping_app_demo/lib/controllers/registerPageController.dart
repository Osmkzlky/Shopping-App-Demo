import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app_demo/services/auth.dart';
import 'package:shopping_app_demo/services/firebase_services.dart';
import 'package:shopping_app_demo/theme/colors.dart';
import 'package:shopping_app_demo/views/customBottomNavigationBar.dart';

class RegisterPageController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController againPasswordController = TextEditingController();
  bool checkPassword() {
    if (passwordController.text == againPasswordController.text) {
      return true;
    } else {
      return false;
    }
  }

  final formkey = GlobalKey<FormState>();
  Future<void> signUpWithGoogle(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();

      int? counterValue = await FirebaseServices().getCounter();
      if (counterValue != null) {
        await FirebaseServices().updateCounter(counterValue);
        final result = await Auth().signUpWithGoogle(
            id: (counterValue + 1).toString(),
            name: nameController.text,
            surname: surnameController.text,
            birhtday: birthdayController.text,
            gender: "2",
            phone: "",
            favoriteProductIds: [],
            addresses: []);
        if (result == "success") {
          Future.delayed(const Duration(milliseconds: 500))
              .then((value) => Get.to(CustomBottomNavigationBar()));
          await ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: white,
              content: Text(
                "Kayıt Tamamlandı, Anasayfaya Yönlendiriliyor...",
                style: TextStyle(fontWeight: FontWeight.bold, color: blue),
              )));
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
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const CupertinoAlertDialog(
              title: Text("Hata"),
              content: Text("Şifreler Uyuşmuyor. Kontrol et!"),
            );
          },
        );
      }
    }
  }

  Future<void> signUp(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      if (checkPassword()) {
        int? counterValue = await FirebaseServices().getCounter();
        if (counterValue != null) {
          await FirebaseServices().updateCounter(counterValue);
          final result = await Auth().signUp(
              id: (counterValue + 1).toString(),
              email: emailController.text,
              password: passwordController.text,
              name: nameController.text,
              surname: surnameController.text,
              birhtday: birthdayController.text,
              gender: "2",
              phone: "",
              favoriteProductIds: [],
              addresses: []);
          if (result == "success") {
            Future.delayed(const Duration(milliseconds: 500))
                .then((value) => Get.back());
            await ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: white,
                content: Text(
                  "Kayıt Tamamlandı, Giriş Ekranına Yönlendiriliyor...",
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    color: blue,
                  ),
                )));
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
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return const CupertinoAlertDialog(
                title: Text("Hata"),
                content: Text("Şifreler Uyuşmuyor. Kontrol et!"),
              );
            },
          );
        }
      }
    }
  }
}
