import 'package:flutter/material.dart';
import 'package:product_catalog_app/crud_operations/data_service_operations.dart';
import 'package:product_catalog_app/model/catalog_model.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  void initState() {
    super.initState();
    loadFavourites();
  }

  DataServiceOperations dataServiceOperations = DataServiceOperations();
  List<String> favorites = [];
  List<CategoryModel> storeItems = [];

  Future<void> loadFavourites() async {
    favorites = await dataServiceOperations.getFavorites();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favourites')),
      body:
          favorites.isEmpty
              ? LinearProgressIndicator(
                minHeight: 2,
                backgroundColor: Colors.white,
              )
              : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  var item = favorites[index];
                  print('item==$item');
                  // String name = item.name.substring(0, 10);
                  // // String image = item.image;
                  // // String price = item.price;
                  return ListTile(
                    // leading: Image.network(item.image, width: 30, height: 30),
                    // title: Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [Text(name), Text(item.price)],
                    // ),
                  );
                },
              ),
    );
  }
}
