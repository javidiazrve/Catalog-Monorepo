// ignore_for_file: public_member_api_docs, sort_constructors_first
class NewCatalogItemDto {
  String title;
  String description;
  String? category;
  List<String>? tags;

  NewCatalogItemDto({
    required this.title,
    required this.description,
    this.category = "",
    this.tags = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'tags': tags,
    };
  }
}
