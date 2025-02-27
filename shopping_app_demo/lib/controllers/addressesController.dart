import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app_demo/services/auth.dart';

class AddressesController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameContorller = TextEditingController();
  TextEditingController phoneContorller = TextEditingController();
  TextEditingController buildTypeController = TextEditingController();
  TextEditingController cityContoller = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController addressNameController = TextEditingController();
  RxBool isSelect = false.obs;
  void changeSelect() {
    isSelect.value = !isSelect.value;
  }

  final formkey = GlobalKey<FormState>();
  Future<void> addAddress() async {
    if (formkey.currentState!.validate()) {
      nameController.text = "";
      surnameContorller.text = "";
      phoneContorller.text = "";
      buildTypeController.text = "";
      cityContoller.text = "";
      districtController.text = "";
      neighborhoodController.text = "";
      addressNameController.text = "";
      formkey.currentState!.save();
      await Auth().addAddresses(
        address_userName: nameController.text,
        address_userSurname: surnameContorller.text,
        address_userPhone: phoneContorller.text,
        address_city: cityContoller.text,
        address_district: districtController.text,
        address_neighborhood: neighborhoodController.text,
        address_title: addressNameController.text,
        address_name: buildTypeController.text,
      );
    }
  }

  Future<void> updateAddress(int index) async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();

      await Auth().updateAddress(
        index: index,
        address_userName: nameController.text,
        address_userSurname: surnameContorller.text,
        address_userPhone: phoneContorller.text,
        address_city: cityContoller.text,
        address_district: districtController.text,
        address_neighborhood: neighborhoodController.text,
        address_title: addressNameController.text,
        address_name: buildTypeController.text,
      );
    }
  }
}
