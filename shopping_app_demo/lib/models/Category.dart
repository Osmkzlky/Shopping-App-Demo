// ignore_for_file: public_member_api_docs, sort_constructors_first
class Category {
  final String category_name;
  final List product_ids;
  Category({
    required this.category_name,
    required this.product_ids,
  });
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        category_name: json["category_name"] ?? "",
        product_ids: json["product_ids"] ?? []);
  }
}
