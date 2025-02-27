import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopping_app_demo/models/UserData.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Firebase kayıt işlemi
  Future<String?> signUp(
      {required String id,
      required String email,
      required password,
      required String name,
      required String surname,
      required String birhtday,
      required String gender,
      required String phone,
      required List<String> addresses,
      required List<String> favoriteProductIds}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;
      try {
        await _firestore.collection("users").doc(uid).set({
          "id": id,
          "name": name,
          "surname": surname,
          "birhtday": birhtday.toString(),
          "email": email,
          "gender": gender,
          "favoriteProductIds": favoriteProductIds,
          "phone": phone,
          "addresses": addresses
        });
        print("Kullanıcı Kaydı Başarılı");
      } catch (e) {
        print(e);
      }
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "Bu e-posta adresi zaten kullanımda";
      } else if (e.code == "invalid-email") {
        return "Geçersiz e-posta adresi";
      } else if (e.code == "weak-password") {
        return "Şifre çok zayıf. En az 6 karakter kullanın";
      } else if (e.code == "operation-not-allowed") {
        return "E-posta/şifre kaydı etkinleştirilmemiş";
      } else if (e.code == "network-request-failed") {
        return "Ağ bağlantısı hatası";
      } else {
        return "Kayıt olurken bir hata oluştu: ${e.message}";
      }
    } catch (e) {
      return "Beklenmeyen bir hata oluştu:$e";
    }
  }

  Future<String?> sigIn(
      {required String email, required String password}) async {
    String? res;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      try {
        getUserData();
      } catch (e) {
        print(e);
      }
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        res = "Hesap bulunamadı";
      } else if (e.code == "wrong-password") {
        res = "Şifre yanlış";
      } else if (e.code == "invalid-email") {
        res = "Geçersiz e-posta adresi";
      } else if (e.code == "user-disabled") {
        res = "Kullanıcı hesabı devre dışı bırakılmış";
      } else if (e.code == "too-many-requests") {
        res = "Çok fazla istek yapıldı. Lütfen daha sonra tekrar deneyin.";
      } else if (e.code == "operation-not-allowed") {
        res = "E-posta/şifre girişi etkinleştirilmemiş";
      } else if (e.code == "network-request-failed") {
        res = "Ağ bağlantısı hatası";
      } else if (e.code == "weak-password") {
        res = "Şifre çok zayıf, en az 6 karakter olmalı";
      } else if (e.code == "invalid-credential") {
        res = "Geçersiz kimlik bilgileri";
      } else {
        res = "Bilinmeyen hata: ${e.message}";
      }
    } catch (e) {
      res = "Beklenmeyen bir hata oluştu: $e";
    }
    return res;
  }

  Stream<UserData?> getUserData() {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;
      return _firestore
          .collection("users")
          .doc(uid)
          .snapshots()
          .map((snapshot) {
        return UserData.fromJson(snapshot.data() as Map<String, dynamic>);
      });
    } else {
      return Stream.value(null);
    }
  }

  Future<void> sigOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> addFavoriteProductId(String favoriteProductsId) async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        await _firestore.collection("users").doc(uid).update({
          "favoriteProductIds": FieldValue.arrayUnion([favoriteProductsId])
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeFavoriteProductId(String favoriteProductsId) async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        await _firestore.collection("users").doc(uid).update({
          "favoriteProductIds": FieldValue.arrayRemove([favoriteProductsId])
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateNameSurnameGender(
      {required String? name,
      required String? surname,
      required String? gender}) async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        Map<String, dynamic> updateData = {};
        if (name != null) updateData["name"] = name;
        if (surname != null) updateData["surname"] = surname;
        if (gender != null) updateData["gender"] = gender;
        await _firestore.collection("users").doc(uid).update(updateData);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updatePhoneEmail(
      {required String? email, required String? phone}) async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        Map<String, dynamic> updateData = {};
        if (email != null) updateData["email"] = email;
        if (phone != null) updateData["phone"] = phone;
        await _firestore.collection("users").doc(uid).update(updateData);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addAddresses(
      {required String? address_userName,
      required String? address_userSurname,
      required String? address_userPhone,
      required String? address_city,
      required String? address_district,
      required String? address_neighborhood,
      required String? address_title,
      required String? address_name}) async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        Map<String, dynamic> updateData = {};
        if (address_userName != null)
          updateData["address_userName"] = address_userName;
        if (address_userSurname != null)
          updateData["address_userSurname"] = address_userSurname;
        if (address_userPhone != null)
          updateData["address_userPhone"] = address_userPhone;
        if (address_city != null) updateData["address_city"] = address_city;
        if (address_district != null)
          updateData["address_district"] = address_district;
        if (address_neighborhood != null)
          updateData["address_neighborhood"] = address_neighborhood;
        if (address_title != null) updateData["address_title"] = address_title;
        if (address_name != null) updateData["address_name"] = address_name;
        await _firestore.collection("users").doc(uid).update({
          "addresses": FieldValue.arrayUnion([updateData])
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateAddress(
      {required int index,
      required String? address_userName,
      required String? address_userSurname,
      required String? address_userPhone,
      required String? address_city,
      required String? address_district,
      required String? address_neighborhood,
      required String? address_title,
      required String? address_name}) async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        DocumentSnapshot userDoc =
            await _firestore.collection("users").doc(uid).get();
        List<dynamic> addresses = userDoc["addresses"] ?? [];
        Map<String, dynamic> currentAddress =
            Map<String, dynamic>.from(addresses[index]);

        if (address_userName != null)
          currentAddress["address_userName"] = address_userName;
        if (address_userSurname != null)
          currentAddress["address_userSurname"] = address_userSurname;
        if (address_userPhone != null)
          currentAddress["address_userPhone"] = address_userPhone;
        if (address_city != null) currentAddress["address_city"] = address_city;
        if (address_district != null)
          currentAddress["address_district"] = address_district;
        if (address_neighborhood != null)
          currentAddress["address_neighborhood"] = address_neighborhood;
        if (address_title != null)
          currentAddress["address_title"] = address_title;
        if (address_name != null) currentAddress["address_name"] = address_name;
        addresses[index] = currentAddress;
        await _firestore.collection("users").doc(uid).update({
          "addresses": addresses,
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteAddressAtIndex(int index) async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        DocumentSnapshot userDoc =
            await _firestore.collection("users").doc(uid).get();
        List<dynamic> addresses = userDoc["addresses"] ?? [];
        addresses.removeAt(index);
        await _firestore.collection("users").doc(uid).update({
          "addresses": addresses,
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      final userCredential = await _firebaseAuth.signInWithCredential(cred);
      final user = userCredential.user;
      if (user != null) {
        final userData =
            await _firestore.collection("users").doc(user.uid).get();
        if (userData.exists) {
          return true;
        } else
          return false;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String?> signUpWithGoogle(
      {required String id,
      required String name,
      required String surname,
      required String birhtday,
      required String gender,
      required String phone,
      required List<String> addresses,
      required List<String> favoriteProductIds}) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      final userCredential = await _firebaseAuth.signInWithCredential(cred);
      final user = userCredential.user!;
      try {
        await _firestore.collection("users").doc(user.uid).set({
          "id": id,
          "name": name,
          "surname": surname,
          "birhtday": birhtday.toString(),
          "email": user.email,
          "gender": gender,
          "favoriteProductIds": favoriteProductIds,
          "phone": phone,
          "addresses": addresses
        });
        print("Kayıt Başarılı");
      } catch (e) {
        print(e);
      }
      return "success";
    } catch (e) {
      "Beklenmeyen bir hata oldu ${e}";
    }
  }

  Future<void> sendPasswordResetLink({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }
}
