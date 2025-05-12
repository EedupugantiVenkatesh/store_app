import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:product_catalog_app/model/catalog_model.dart';
import 'package:product_catalog_app/constants/app_constants.dart';

class DataServiceOperations {

  Future<void> saveFavorites(List<String> items) async {
    try {
      final pref = await SharedPreferences.getInstance();
      await pref.setStringList(AppConstants.favoritesKey, items);
    } catch (e) {
      print('${AppConstants.errorLoadingFavorites}: $e');
      rethrow;
    }
  }

  Future<List<String>> getFavorites() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final List<String> favorites = pref.getStringList(AppConstants.favoritesKey) ?? [];
      print('Loaded favorites: $favorites');
      return favorites;
    } catch (e) {
      print('${AppConstants.errorLoadingFavorites}: $e');
      return [];
    }
  }

  Future<void> saveStoreItems(List<CategoryModel> items) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> itemsJson = items.map((item) => item.toJson()).toList();
      await pref.setString(AppConstants.storeItemsKey, jsonEncode(itemsJson));
    } catch (e) {
      print('${AppConstants.errorLoadingStoreItems}: $e');
      rethrow;
    }
  }

  Future<List<CategoryModel>> getStoreItems() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final String? itemsJson = pref.getString(AppConstants.storeItemsKey);
      if (itemsJson == null) return [];
      
      final List<dynamic> decoded = jsonDecode(itemsJson);
      return decoded.map((item) => CategoryModel.fromJson(item)).toList();
    } catch (e) {
      print('${AppConstants.errorLoadingStoreItems}: $e');
      return [];
    }
  }

  /// Clears all stored data (for testing or reset purposes)
  Future<void> clearAllData() async {
    try {
      final pref = await SharedPreferences.getInstance();
      await pref.remove(AppConstants.favoritesKey);
      await pref.remove(AppConstants.storeItemsKey);
    } catch (e) {
      print('Error clearing data: $e');
      rethrow;
    }
  }
} 