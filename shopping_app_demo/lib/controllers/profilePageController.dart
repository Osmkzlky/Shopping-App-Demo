import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePageController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxInt genderIndex = 2.obs;
  void updateGenderIndex(int value) {
    genderIndex.value = value;
  }
}
