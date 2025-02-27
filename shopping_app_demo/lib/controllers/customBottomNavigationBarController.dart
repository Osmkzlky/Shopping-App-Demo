import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBarController extends GetxController {
  RxInt bottomIndex = 0.obs;
  void updateBottomIndex(int index) {
    bottomIndex.value = index;
  }

  Map<String, IconData> bottomNavContent = {
    "Anasayfa": FontAwesomeIcons.house,
    "Kategoriler": FontAwesomeIcons.bars,
    "Sepetim": FontAwesomeIcons.bagShopping,
    "Favorilerim": FontAwesomeIcons.solidBookmark,
    "Hesabım": FontAwesomeIcons.solidUser
  };
}
