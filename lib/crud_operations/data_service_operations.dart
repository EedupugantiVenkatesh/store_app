import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:product_catalog_app/model/catalog_model.dart';

class DataServiceOperations {
  static const String FAVORITES_KEY = 'favorites';
  static const String STORE_ITEMS_KEY = 'store_items';

  Future<void> saveFavorites(List<String> items) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setStringList(FAVORITES_KEY, items);
  }

  Future<List<String>> getFavorites() async {
    final pref = await SharedPreferences.getInstance();
    List<String> favorites = pref.getStringList(FAVORITES_KEY) ?? [];
    print('Loaded from favorites: $favorites');
    return favorites;
  }

  Future<void> saveStoreItems(List<CategoryModel> items) async {
    final pref = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> itemsJson = items.map((item) => {
      'id': item.id,
      'name': item.name,
      'image': item.image,
      'price': item.price,
      'description': item.description,
      'category': item.category,
    }).toList();
    await pref.setString(STORE_ITEMS_KEY, jsonEncode(itemsJson));
  }

  Future<List<CategoryModel>> getStoreItems() async {
    final pref = await SharedPreferences.getInstance();
    final String? itemsJson = pref.getString(STORE_ITEMS_KEY);
    if (itemsJson == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(itemsJson);
      return decoded.map((item) => CategoryModel(
        id: item['id'].toString(),
        name: item['name'].toString(),
        image: item['image'].toString(),
        price: item['price'].toString(),
        description: item['description']?.toString(),
        category: item['category']?.toString(),
      )).toList();
    } catch (e) {
      print('Error loading store items: $e');
      return [];
    }
  }
}
