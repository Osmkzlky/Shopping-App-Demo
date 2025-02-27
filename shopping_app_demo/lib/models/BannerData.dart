// ignore_for_file: public_member_api_docs, sort_constructors_first
class BannerData {
  final String banner_name;
  final String banner_image;
  final List product_ids;
  BannerData({
    required this.banner_name,
    required this.banner_image,
    required this.product_ids,
  });
  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
        banner_name: json["banner_name"],
        banner_image: json["banner_image"],
        product_ids: json["product_ids"]);
  }
}
