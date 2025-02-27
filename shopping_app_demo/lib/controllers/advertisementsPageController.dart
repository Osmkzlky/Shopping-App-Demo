import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdvertisementsPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // controller tanımlama
  late AnimationController _animationController;
  late Animation _animation;
  Animation get animation => this._animation;
  AnimationController get animationController => this._animationController;
  late PageController _pageController;
  PageController get pageController => this._pageController;

  @override
  void onInit() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(seconds: 5)); //zamanlayıcınını süresi
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        update();
      });
    _animationController.forward().whenComplete(nextAdvertisement);
    _pageController = PageController(initialPage: 0);
    super.onInit();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // 1) Ekranı yukarı kaydırdığımızda zaman durdurmak için
  // 2) Sayfaya basılı tuttuğumuzda zamanı durdurmak için
  void timerStop() {
    _animationController.stop();
  }

  void timerStart(int numberOfAdvertisement) {
    _animationController
        .forward()
        .whenComplete(() => exitPage(numberOfAdvertisement));
  }

  // Her sayfa değiştiğinde zaman resetlenip yeniden başlatıyoruz
  void timerReset(int numberOfAdvertisement) {
    _animationController.reset();
    _animationController
        .forward()
        .whenComplete(() => exitPage(numberOfAdvertisement));
  }

  // kampanya sayısı aşınca anasayfaya dönüyoruz
  void exitPage(int numberOfAdvertisement) {
    int currentPage = _pageController.page?.toInt() ?? 0;

    if (currentPage == numberOfAdvertisement - 1) {
      Get.back();
    } else {
      nextAdvertisement();
    }
  }

  // Anasayfa da seçilen resmin açılması için
  void changeInitialPage(int index) {
    _pageController = PageController(initialPage: index);
  }

  // Sonraki kampanyaya geçmesi için
  void nextAdvertisement() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCirc);
    // Her sayfa geçişinde zamanı resetlemek için
    _animationController.reset();
    // resetlenen animationController tekrardan başlatıyor.
    _animationController.forward().whenComplete(() => nextAdvertisement());
  }

  // sayfalar her değiştinde indeksi güncellemek için
  // neden indeksi güncelliyoruz
  // ProductListe doğru indeksi göndermek için
  RxInt currentIndex = 0.obs;
  void updateCurrentIndex(int index) {
    currentIndex.value = index;
  }
}
