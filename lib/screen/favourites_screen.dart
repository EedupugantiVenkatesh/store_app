import 'package:flutter/material.dart';
import 'package:product_catalog_app/crud_operations/data_service_operations.dart';
import 'package:product_catalog_app/model/catalog_model.dart';

class FavouritesScreen extends StatefulWidget {
  final List<CategoryModel> allItems2;

  const FavouritesScreen({super.key, required this.allItems2});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  DataServiceOperations dataServiceOperations = DataServiceOperations();
  List<String> favorites = [];
  List<CategoryModel> favouriteItems = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadFavourites();
  }

  @override
  void didUpdateWidget(FavouritesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.allItems2 != widget.allItems2) {
      loadFavourites();
    }
  }

  Future<void> loadFavourites() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      favorites = await dataServiceOperations.getFavorites();
      print('Loaded favorites: $favorites');

      // Filter the passed items
      favouriteItems = widget.allItems2
          .where((item) => favorites.contains(item.id))
          .toList();
      print('Filtered favourite items: ${favouriteItems.length}');
    } catch (e) {
      error = e.toString();
      print('Error loading favorites: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favourites')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : favouriteItems.isEmpty
                  ? Center(child: Text("No Favourites Found"))
                  : ListView.builder(
                      itemCount: favouriteItems.length,
                      itemBuilder: (context, index) {
                        var item = favouriteItems[index];
                        String name = item.name.length > 10
                            ? item.name.substring(0, 10)
                            : item.name;

                        return ListTile(
                          leading: Image.network(
                            item.image,
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text(name), Text(item.price)],
                          ),
                        );
                      },
                    ),
    );
  }
}