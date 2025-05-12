import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  DataServiceOperations dataServiceOperations = DataServiceOperations();
  List<CategoryModel> storeItems = [];
  List<String> favorites = [];
  String productsApi = 'https://fakestoreapi.com/products';
  List<Map<String, dynamic>> map = [];
  bool isLoading = true;
  String? error;

  Future<void> loadInitialData() async {
    // Load both favorites and store items from persistent storage
    await loadFavorites();
    await loadStoreItems();
    
    // If no items in storage, fetch from API
    if (storeItems.isEmpty) {
      await fetchDataFromApi();
    } else {
      // Notify parent about loaded items
      widget.onItemsLoaded?.call(storeItems);
    }
  }

  Future<void> loadFavorites() async {
    favorites = await dataServiceOperations.getFavorites();
    setState(() {});
  }

  Future<void> loadStoreItems() async {
    storeItems = await dataServiceOperations.getStoreItems();
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
      var response = await http.get(Uri.parse(productsApi));
      if (response.statusCode == 200) {
        map = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        storeItems = map.map((item) {
          return CategoryModel(
            id: item['id'].toString(),
            name: item['title'].toString(),
            image: item['image'].toString(),
            price: item['price'].toString(),
            description: item['description']?.toString(),
            category: item['category']?.toString(),
          );
        }).toList();
        
        // Save items to persistent storage
        await dataServiceOperations.saveStoreItems(storeItems);
        
        // Notify parent about loaded items
        widget.onItemsLoaded?.call(storeItems);
      } else {
        error = 'Failed to load products';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void addtoFavorites(String id) async {
    setState(() {
      if (favorites.contains(id)) {
        favorites.remove(id);
      } else {
        favorites.add(id);
      }
    });
    await dataServiceOperations.saveFavorites(favorites);
  }

  void _navigateToDetail(CategoryModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          product: product,
          favorites: favorites,
          onFavoriteToggle: addtoFavorites,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Store')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : RefreshIndicator(
                  onRefresh: fetchDataFromApi,
                  child: ListView.builder(
                    itemCount: storeItems.length,
                    itemBuilder: (context, index) {
                      var item = storeItems[index];
                      String name = item.name.length > 30
                          ? '${item.name.substring(0, 30)}...'
                          : item.name;
                      var isFav = favorites.contains(item.id);
                      return ListTile(
                        onTap: () => _navigateToDetail(item),
                        leading: Image.network(
                          item.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                        title: Text(name),
                        subtitle: Text('\$${item.price}'),
                        trailing: IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : null,
                          ),
                          onPressed: () => addtoFavorites(item.id),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
