// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserData {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String birhtday;
  final String gender;
  final String phone;
  final List favoriteProductIds;
  final List addresses;
  UserData({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.birhtday,
    required this.gender,
    required this.phone,
    required this.favoriteProductIds,
    required this.addresses,
  });
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        surname: json["surname"] ?? "",
        email: json["email"] ?? "",
        birhtday: json["birhtday"] ?? "",
        gender: json["gender"] ?? "",
        phone: json["phone"] ?? "",
        favoriteProductIds: json["favoriteProductIds"] ?? [],
        addresses: json["addresses"] ?? []);
  }
}
