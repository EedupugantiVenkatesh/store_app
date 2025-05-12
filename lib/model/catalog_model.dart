class CategoryModel {
  final String id;
  final String name;
  final String image;
  final String price;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'].toString(),
      name: json['name'],
      image: json['image'],
      price: json['price'].toString(),
    );
  }
}