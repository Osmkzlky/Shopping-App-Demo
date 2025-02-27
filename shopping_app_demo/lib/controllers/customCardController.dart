import 'package:get/get.dart';

class CustomCardController extends GetxController {
  // Yorumlara gelen puanların ortalamasın almak için
  RxString starAverage = "0.0".obs;
  @override
  void onInit() {
    starAverage.value = "0.0";
    super.onInit();
  }

  void starAverageFun(List reviews) {
    double toplam = 0;
    if (reviews.length != 0) {
      for (Map i in reviews) {
        toplam += double.parse(i["star"]);
      }
      starAverage.value = (toplam / reviews.length).toStringAsFixed(1);
    }
  }

  RxBool isSaved = false.obs;
  void updateIsSaved() {
    isSaved.value = !isSaved.value;
  }
}
