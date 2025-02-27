// ignore_for_file: public_member_api_docs, sort_constructors_first

class Shopping {
  final String product_id;
  final String product_name;
  final String product_image;
  final String product_color;
  final Map product_price;
  final String user_id;
  final String user_name;
  final String user_surname;
  final String shopping_status;
  final String shopping_id;
  final String shopping_date;
  final String shopping_count;
  final List<Map> additionalServices;

  Shopping({
    required this.product_id,
    required this.product_name,
    required this.product_image,
    required this.product_color,
    required this.user_id,
    required this.user_name,
    required this.user_surname,
    required this.shopping_status,
    required this.shopping_id,
    required this.shopping_date,
    required this.shopping_count,
    required this.additionalServices,
    required this.product_price,
  });
  factory Shopping.fromJson(Map<String, dynamic> json) {
    return Shopping(
        product_id: json["product_id"] ?? "",
        product_name: json["product_name"] ?? "",
        product_image: json["product_image"] ?? "",
        product_color: json["product_color"] ?? "",
        product_price: json["product_price"] ?? {},
        user_id: json["user_id"] ?? "",
        user_name: json["user_name"] ?? "",
        user_surname: json["user_surname"],
        shopping_status: json["shopping_status"] ?? "",
        shopping_id: json["shopping_id"] ?? "",
        shopping_date: json["shopping_date"] ?? "",
        shopping_count: json["shopping_count"] ?? "",
        additionalServices: List<Map>.from(json["additionalServices"] ?? []));
  }
}
