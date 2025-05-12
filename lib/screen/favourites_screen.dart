import 'package:flutter/material.dart';
import 'package:product_catalog_app/constants/app_constants.dart';
import 'package:product_catalog_app/crud_operations/data_service_operations.dart';
import 'package:product_catalog_app/model/catalog_model.dart';
import 'package:product_catalog_app/screen/product_detail_screen.dart';

class FavouritesScreen extends StatefulWidget {
  final List<CategoryModel> allItems;
  final Function(String) onFavoriteToggle;

  const FavouritesScreen({
    super.key,
    required this.allItems,
    required this.onFavoriteToggle,
  });

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final DataServiceOperations _dataService = DataServiceOperations();
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
    if (oldWidget.allItems != widget.allItems) {
      loadFavourites();
    }
  }

  Future<void> loadFavourites() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      favorites = await _dataService.getFavorites();
      print('Loaded favorites in FavouritesScreen: $favorites');

      // Filter the passed items
      favouriteItems = widget.allItems
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

  void _navigateToDetail(CategoryModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          product: product,
          favorites: favorites,
          onFavoriteToggle: widget.onFavoriteToggle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.favoritesTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadFavourites,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : favouriteItems.isEmpty
                  ? Center(child: Text(AppConstants.noFavoritesFound))
                  : RefreshIndicator(
                      onRefresh: loadFavourites,
                      child: ListView.builder(
                        itemCount: favouriteItems.length,
                        itemBuilder: (context, index) {
                          final item = favouriteItems[index];
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
                              onPressed: () => widget.onFavoriteToggle(item.id),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}