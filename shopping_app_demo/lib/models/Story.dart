// ignore_for_file: public_member_api_docs, sort_constructors_first
class Story {
  final String story_name;
  final String story_image;
  final List product_ids;
  Story({
    required this.story_name,
    required this.story_image,
    required this.product_ids,
  });
  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
        story_name: json["story_name"],
        story_image: json["story_image"],
        product_ids: json["product_ids"]);
  }
}
