import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:product_catalog_app/model/catalog_model.dart';
import 'package:product_catalog_app/constants/app_constants.dart';

class DataServiceOperations {

  Future<void> saveFavorites(List<String> items) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setStringList(AppConstants.favoritesKey, items);
  }

  Future<List<String>> getFavorites() async {
    final pref = await SharedPreferences.getInstance();
    List<String> favorites = pref.getStringList(AppConstants.favoritesKey) ?? [];
    print('Loaded from favorites: $favorites');
    return favorites;
  }

  Future<void> saveStoreItems(List<CategoryModel> items) async {
    final pref = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> itemsJson = items.map((item) => item.toJson()).toList();
    await pref.setString(AppConstants.storeItemsKey, jsonEncode(itemsJson));
  }

  Future<List<CategoryModel>> getStoreItems() async {
    final pref = await SharedPreferences.getInstance();
    final String? itemsJson = pref.getString(AppConstants.storeItemsKey);
    if (itemsJson == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(itemsJson);
      return decoded.map((item) => CategoryModel.fromJson(item)).toList();
    } catch (e) {
      print(AppConstants.errorLoadingStoreItems);
      return [];
    }
  }
}
