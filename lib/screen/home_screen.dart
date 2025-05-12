import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_catalog_app/constants/app_constants.dart';
import 'package:product_catalog_app/crud_operations/data_service_operations.dart';
import 'package:product_catalog_app/model/catalog_model.dart';
import 'package:product_catalog_app/screen/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(List<CategoryModel>)? onItemsLoaded;
  const HomeScreen({super.key, this.onItemsLoaded});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataServiceOperations _dataService = DataServiceOperations();
  List<CategoryModel> storeItems = [];
  List<String> favorites = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await loadFavorites();
    await loadStoreItems();
    
    if (storeItems.isEmpty) {
      await fetchDataFromApi();
    } else {
      widget.onItemsLoaded?.call(storeItems);
    }
  }

  Future<void> loadFavorites() async {
    favorites = await _dataService.getFavorites();
    setState(() {});
  }

  Future<void> loadStoreItems() async {
    storeItems = await _dataService.getStoreItems();
    if (storeItems.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchDataFromApi() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.productsEndpoint}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        storeItems = decoded.map((item) => CategoryModel.fromJson(item)).toList();
        
        await _dataService.saveStoreItems(storeItems);
        widget.onItemsLoaded?.call(storeItems);
      } else {
        error = AppConstants.errorLoadingProducts;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToDetail(CategoryModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          product: product,
          favorites: favorites,
          onFavoriteToggle: _toggleFavorite,
        ),
      ),
    );
  }

  Future<void> _toggleFavorite(String id) async {
    setState(() {
      if (favorites.contains(id)) {
        favorites.remove(id);
      } else {
        favorites.add(id);
      }
    });
    await _dataService.saveFavorites(favorites);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppConstants.homeTitle)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : RefreshIndicator(
                  onRefresh: fetchDataFromApi,
                  child: ListView.builder(
                    itemCount: storeItems.length,
                    itemBuilder: (context, index) {
                      final item = storeItems[index];
                      final isFav = favorites.contains(item.id);
                      
                      return ListTile(
                        onTap: () => _navigateToDetail(item),
                        leading: Image.network(
                          item.image,
                          width: AppConstants.listImageSize,
                          height: AppConstants.listImageSize,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => 
                              const Icon(Icons.error),
                        ),
                        title: Text(item.truncatedName),
                        subtitle: Text(item.formattedPrice),
                        trailing: IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : null,
                          ),
                          onPressed: () => _toggleFavorite(item.id),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
