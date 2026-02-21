




class CategoriesResponseModel {
  final String slug;
  final String name;
  final String url;

  CategoriesResponseModel({
    required this.slug,
    required this.name,
    required this.url,
  });

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoriesResponseModel(
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "slug": slug,
      "name": name,
      "url": url,
    };
  }
}