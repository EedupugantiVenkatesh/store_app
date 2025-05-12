import 'package:product_catalog_app/constants/app_constants.dart';

class CategoryModel {
  final String id;
  final String name;
  final String image;
  final String price;
  final String? description;
  final String? category;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.description,
    this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'description': description,
      'category': category,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'].toString(),
      name: json['title']?.toString() ?? json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      price: json['price']?.toString() ?? '0.0',
      description: json['description']?.toString(),
      category: json['category']?.toString(),
    );
  }

  String get formattedPrice => '${AppConstants.pricePrefix}$price';

  String get truncatedName => name.length > AppConstants.maxTitleLength
      ? '${name.substring(0, AppConstants.maxTitleLength)}...'
      : name;
}