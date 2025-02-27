import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  PageController pageController = PageController(initialPage: 0);
  Timer? timer;
  int _currentPage = 1;
  int numberOfBanner = 0;

  int bannerPageIndex = 0;

  void bannerAnimation() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < numberOfBanner - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (pageController.hasClients) {
        pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }
}
