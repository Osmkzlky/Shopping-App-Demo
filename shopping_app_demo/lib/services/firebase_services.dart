import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app_demo/models/BannerData.dart';
import 'package:shopping_app_demo/models/Category.dart';
import 'package:shopping_app_demo/models/Product.dart';
import 'package:shopping_app_demo/models/Shopping.dart';
import 'package:shopping_app_demo/models/Story.dart';

class FirebaseServices {
  final productCol = FirebaseFirestore.instance.collection("productList");
  Future<Products> getAllProducts() async {
    try {
      final querySnapshot = await productCol.get();

      final List<Map<String, dynamic>> productList =
          querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();

        return data;
      }).toList();

      final products = Products.fromJson({"productList": productList});

      return products;
    } catch (e) {
      throw Exception("Ürünler alınırken hata oluştu: $e");
    }
  }

  final categoryCol = FirebaseFirestore.instance.collection("homeCategory");
  Future<List<Category>> getCategory() async {
    List<Category> categoryList = [];
    final categoryDoc = await categoryCol
        .doc("GUCr1Cp48IW5SZwbFhc3")
        .get()
        .then((value) => value.data());
    if (categoryDoc != null) {
      List categoriesData = categoryDoc["category"] ?? [];
      categoryList = categoriesData.map((categoryData) {
        return Category.fromJson(categoryData);
      }).toList();
    }
    return categoryList;
  }

  final storiesCol = FirebaseFirestore.instance.collection("stories");
  Stream<List<Story>> getStories() {
    return storiesCol.doc("elAVddV5gn1PmvUbOX1G").snapshots().map((snapshot) {
      if (snapshot.exists) {
        final storiesDoc = snapshot.data();
        if (storiesDoc != null) {
          List storiesData = storiesDoc["storyContent"] ?? [];
          return storiesData.map<Story>((storyData) {
            return Story.fromJson(storyData);
          }).toList();
        }
      }
      return <Story>[];
    });
  }

  final bannerCol = FirebaseFirestore.instance.collection("banners");
  Stream<List<BannerData>> getBanners() {
    return bannerCol.doc("0xLkrcwXdCe8pvUIwZtI").snapshots().map((snapshot) {
      if (snapshot.exists) {
        final bannerDoc = snapshot.data();
        if (bannerDoc != null) {
          List bannersData = bannerDoc["bannerContent"] ?? [];

          return bannersData.map<BannerData>((bannerData) {
            return BannerData.fromJson(bannerData);
          }).toList();
        }
      }
      return <BannerData>[];
    });
  }

  Future<void> saveShoppingList(List<Shopping> shoppingList) async {
    final shoppingListCol =
        FirebaseFirestore.instance.collection("shoppingList");
    try {
      final shoppingListDoc = await shoppingListCol.add({});
      for (Shopping shopping in shoppingList) {
        await shoppingListDoc.collection(shopping.user_id).add({
          "product_id": shopping.product_id,
          "product_name": shopping.product_name,
          "product_color": shopping.product_color,
          "product_image": shopping.product_image,
          "user_id": shopping.user_id,
          "user_name": shopping.user_name,
          "user_surname": shopping.user_surname,
          "shopping_status": shopping.shopping_status,
          "shopping_id": shopping.shopping_id,
          "shopping_date": shopping.shopping_date,
          "shopping_count": shopping.shopping_count,
          "additionalServices": shopping.additionalServices,
          "product_price": shopping.product_price
        });
        print("Kayıt Başarılı");
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<List<Shopping>> getShoppingList(String userId) {
    final shoppingListCol =
        FirebaseFirestore.instance.collection("shoppingList");
    return shoppingListCol.snapshots().asyncMap((querySnapshot) async {
      List<Shopping> userShoppingList = [];
      for (var doc in querySnapshot.docs) {
        final shoppinfItemsSnapshot =
            await doc.reference.collection(userId).get();
        for (var item in shoppinfItemsSnapshot.docs) {
          userShoppingList.add(Shopping.fromJson(item.data()));
        }
      }
      return userShoppingList;
    });
  }

  Future<void> addProductReview({
    required String product_id,
    required String? star,
    required String? comment,
    required String? user_id,
    required String? user_name,
    required String? user_surname,
  }) async {
    Map addReviewMap = {};
    try {
      if (star != null) addReviewMap["star"] = star;
      if (comment != null) addReviewMap["comment"] = comment;
      if (user_id != null) addReviewMap["user_id"] = user_id;
      if (user_name != null) addReviewMap["user_name"] = user_name;
      if (user_surname != null) addReviewMap["user_surname"] = user_surname;
      addReviewMap["date"] = DateFormat("dd/MM/yyyy").format(DateTime.now());
      await productCol.doc(product_id).update({
        "product_reviews": FieldValue.arrayUnion([addReviewMap])
      });
    } catch (e) {
      print("Error adding review: $e");
    }
  }

  final counterCol = FirebaseFirestore.instance.collection("counter");
  Future<int?> getCounter() async {
    final counterDoc = await counterCol
        .doc("MCAeRCoH5mFtZmN6V6Jc")
        .get()
        .then((value) => value.data());
    int? counterValue = counterDoc?['counterValue'];
    return counterValue;
  }

  Future<void> updateCounter(int value) async {
    await counterCol
        .doc("MCAeRCoH5mFtZmN6V6Jc")
        .update({"counterValue": (value + 1)})
        .then((_) => print("Counter updated successfully"))
        .catchError((error) => print("Failed to update counter: $error"));
  }
}
