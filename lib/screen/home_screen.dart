import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_catalog_app/crud_operations/data_service_operations.dart';
import 'package:product_catalog_app/model/catalog_model.dart';
import 'package:product_catalog_app/screen/favourites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
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

  void addtoFavorites(String id) {
    setState(() {
      if (favorites.contains(id)) {
        favorites.remove(id); 
      } else {
        favorites.add(id); 
      }
      dataServiceOperations.saveFavorites(favorites);
    });
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
                    var isFav = favorites.contains(item.id);
                    return ListTile(
                      leading: Image.network(item.image, width: 30, height: 30),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(name), Text(item.price)],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      FavouritesScreen(allItems: storeItems),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
