import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_catalog_app/operations/data_service_operations.dart';
import 'package:product_catalog_app/model/catalog_model.dart';
import 'package:product_catalog_app/screen/favourites_screen.dart';
import 'package:product_catalog_app/screen/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(List<CategoryModel>) onItemsLoaded;

  const HomeScreen({super.key, required this.onItemsLoaded});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
    loadFavorites();
  }

  DataServiceOperations dataServiceOperations = DataServiceOperations();
  List<CategoryModel> storeItems = [];
  List<String> favorites = [];
  String productsApi = 'https://fakestoreapi.com/products';
  List<Map<String, dynamic>> map = [];
  bool isLoading = true;
  String? error;

  Future<void> fetchDataFromApi() async {
    if (storeItems.isNotEmpty) return;
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      var response = await http.get(Uri.parse(productsApi));
      if (response.statusCode == 200) {
        map = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        storeItems =
            map.map((item) {
              return CategoryModel(
                id: item['id'].toString(),
                name: item['title'].toString(),
                image: item['image'].toString(),
                price: item['price'].toString(),
              );
            }).toList();
        widget.onItemsLoaded(storeItems);
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

  Future<void> loadFavorites() async {
    favorites = await dataServiceOperations.getFavorites();
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Store')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : error != null
              ? Center(child: Text(error!))
              : RefreshIndicator(
                onRefresh: fetchDataFromApi,
                child: ListView.builder(
                  itemCount: storeItems.length,
                  itemBuilder: (context, index) {
                    var item = storeItems[index];
                    String name = item.name.substring(0, 10);
                    return ListTile(
                      leading: Image.network(item.image, width: 30, height: 30),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(name), Text(item.price)],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          favorites.contains(item.id) ? Icons.favorite : Icons.favorite_border,
                          color: favorites.contains(item.id) ? Colors.red : null,
                        ),
                        onPressed: () => addtoFavorites(item.id),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              product: item,
                              favorites: favorites,
                              onFavoriteToggle: addtoFavorites,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
    );
  }
}
