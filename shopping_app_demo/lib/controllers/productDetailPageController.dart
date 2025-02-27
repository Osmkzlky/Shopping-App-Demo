import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app_demo/models/Product.dart';
import 'package:shopping_app_demo/models/Shopping.dart';

class ProductDetailPageController extends GetxController {
  // renge bastığımızda indeksi değiştiriyoruz
  RxInt colorIndex = 0.obs;
  void updateColorIndex(int index) {
    colorIndex.value = index;
  }

// fiyata bastığımızda indeksi değiştiriyoruz
  RxInt priceIndex = 0.obs;
  void updatePriceIndex(int index) {
    priceIndex.value = index;
  }

  // fiyat değiştirme fonksiyonu
  RxString customPrice = "0.0".obs;
  void updateCustomPrice(String price) {
    customPrice.value = price;
    customPrice.value = changeFormatPrice(int.parse(customPrice.value));
  }

// price ın tl formatına dönüştürüyoruz
  String changeFormatPrice(int newPrice) {
    String formatPrice = NumberFormat.currency(
      locale: 'tr_TR',
      symbol: '',
      decimalDigits: 0,
    ).format(newPrice);
    return formatPrice;
  }

  // textin ilk harfini gösterip kalanını * yapan fonksiyon
  String maskName(String text) {
    if (text.isEmpty) return "";
    return text[0] + '*' * (text.length - 1);
  }

  // Veri örnek 12.999 şeklinde geliyor toplamda sorun olamaması için aynı formatta dönüştürüp yapıyoruz
  // Bu yüzden changeFormantPrice kulannıyoruz.
  void additionalServicePrice(bool isSelect, String price) {
    if (isSelect) {
      double toplam = double.parse(customPrice.value) +
          double.parse(changeFormatPrice(int.parse(price)));
      customPrice.value = toplam.toStringAsFixed(3);
    } else {
      double toplam = double.parse(customPrice.value) -
          double.parse(changeFormatPrice(int.parse(price)));
      customPrice.value = toplam.toStringAsFixed(3);
    }
  }

  // Ek servislerin seçilme durumunu kontrol ediyoruz.
  // Obx in değişiklikleri anlamak için listeye ekleme ya da çıkarma yapmalıyız map in içindeki değişiklikleri takip edemiyor
  RxList<Map> newAdditionalServicesList = <Map>[].obs;

  void updateNewAdditionalServicesList(int index) {
    if (newAdditionalServicesList[index]["isSelect"] == true) {
      newAdditionalServicesList[index]["isSelect"] = false;
      newAdditionalServicesList[index] =
          Map<String, dynamic>.from(newAdditionalServicesList[index]);
      additionalServicePrice(
          false, newAdditionalServicesList[index]["additionalService_price"]);
    } else {
      newAdditionalServicesList[index]["isSelect"] = true;
      newAdditionalServicesList[index] =
          Map<String, dynamic>.from(newAdditionalServicesList[index]);
      additionalServicePrice(
          true, newAdditionalServicesList[index]["additionalService_price"]);
    }
  }

  List<Map> cartAdditionalServicesList = [];
  void cartAdditionalServices() {
    cartAdditionalServicesList = [];
    for (int i = 0; i < newAdditionalServicesList.length; i++) {
      if (newAdditionalServicesList[i]["isSelect"] == true) {
        Map cartAdditionalServicesMap = {
          "additionalService_name": newAdditionalServicesList[i]
              ["additionalService_name"],
          "additionalService_price": newAdditionalServicesList[i]
              ["additionalService_price"]
        };
        cartAdditionalServicesList.add(cartAdditionalServicesMap);
      }
    }
  }

  RxList<Shopping> shoppingList = <Shopping>[].obs;
  RxString totalPrice = "0.0".obs;
  void totalPriceFun() {
    double toplam = 0.0;
    for (int i = 0; i < shoppingList.length; i++) {
      toplam = double.parse(totalPrice.value) +
          double.parse(shoppingList[i].product_price.values.first);
    }
    totalPrice.value = toplam.toStringAsFixed(3);
  }

  RxList<String> lastVisitedList = <String>[].obs;

  void addLastVisited(String product_id) {
    if (lastVisitedList.length == 6) {
      lastVisitedList.removeAt(0);
    }

    if (!lastVisitedList.contains(product_id)) {
      lastVisitedList.add(product_id);
      print("Liste güncellendi: $lastVisitedList");
    }
  }

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

  RxList<Product> lastSearchList = <Product>[].obs;
  void addLastSearchList(Product product) {
    if (lastSearchList.length == 8) {
      lastSearchList.removeAt(0);
    } else {
      lastSearchList.add(product);
    }
  }

  void deleteSearch(int index) {
    lastSearchList.removeAt(index);
  }
}
