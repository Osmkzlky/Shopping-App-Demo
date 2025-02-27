// ignore_for_file: public_member_api_docs, sort_constructors_first
final List<String> phone_ids = [];
final List<String> computer_ids = [];
final List<String> watch_ids = [];
final List<String> tablet_ids = [];
final List<String> accessory_ids = [];

class Product {
  final String product_id;
  final String product_name;
  final Map product_prices;
  final String product_category;
  final Map product_colors;
  final List product_images;
  final String product_desTitle;
  final String product_desDetail;
  final List<Map> additionalServices;
  final List<Map> product_reviews;
  Product({
    required this.product_id,
    required this.product_name,
    required this.product_prices,
    required this.product_category,
    required this.product_colors,
    required this.product_images,
    required this.product_desTitle,
    required this.product_desDetail,
    required this.additionalServices,
    required this.product_reviews,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_id: json["product_id"] ?? "",
      product_name: json["product_name"] ?? "",
      product_prices: json["product_prices"] ?? {},
      product_category: json["product_category"] ?? "",
      product_colors: json["product_colors"] ?? {},
      product_images: json["product_images"] ?? [],
      product_desTitle: json["product_desTitle"] ?? "",
      product_desDetail: json["product_desDetail"] ?? "",
      additionalServices: List<Map>.from(json["additionalServices"] ?? []),
      product_reviews: List<Map>.from(json["product_reviews"] ?? []),
    );
  }
}

class Products {
  final List<Product> products;
  Products({
    required this.products,
  });
  factory Products.fromJson(Map<String, dynamic>? json) {
    List<Product> products = [];
    if (json != null) {
      for (var i in json["productList"]) {
        Product product = Product.fromJson(i);
        products.add(product);
        if (product.product_category == "telefon") {
          if (!phone_ids.contains(product.product_id)) {
            phone_ids.add(product.product_id);
          }
        } else if (product.product_category == "bilgisayar") {
          if (!computer_ids.contains(product.product_id)) {
            print(product.product_id);
            computer_ids.add(product.product_id);
          }
        } else if (product.product_category == "tablet") {
          if (!tablet_ids.contains(product.product_id)) {
            tablet_ids.add(product.product_id);
          }
        } else if (product.product_category == "saat") {
          if (!watch_ids.contains(product.product_id)) {
            watch_ids.add(product.product_id);
          }
        } else if (product.product_category == "aksesuar") {
          if (!accessory_ids.contains(product.product_id)) {
            accessory_ids.add(product.product_id);
          }
        }
      }
    }
    return Products(products: products);
  }
}
