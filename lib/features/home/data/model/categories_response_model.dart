


import 'dart:convert';

class CategoriesResponseModel {
  String slug;
  String name;
  String url;

  CategoriesResponseModel({
    required this.slug,
    required this.name,
    required this.url,
  });

  factory CategoriesResponseModel.fromRawJson(String str) => CategoriesResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) => CategoriesResponseModel(
    slug: json["slug"],
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "slug": slug,
    "name": name,
    "url": url,
  };
}
