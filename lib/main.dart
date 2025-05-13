import 'package:flutter/material.dart';
import 'package:product_catalog_app/operations/data_service_operations.dart';
import 'package:product_catalog_app/screen/favourites_screen.dart';

import 'model/catalog_model.dart';
import 'screen/home_screen.dart';
import 'constants/app_constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<CategoryModel> storeItems = [];
  List<String> favorites = [];
  final DataServiceOperations _dataService = DataServiceOperations();
  bool _isLoading = true;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const Center(child: CircularProgressIndicator()),
      const Center(child: CircularProgressIndicator()),
    ];
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      favorites = await _dataService.getFavorites();
      _updateScreens();
    } catch (e) {
      print('Error loading initial data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateScreens() {
    setState(() {
      _screens = [
        HomeScreen(
          onItemsLoaded: (items) {
            setState(() {
              storeItems = items;
              _updateScreens();
            });
          },
        ),
        FavouritesScreen(
          allItems: storeItems,
          // onFavoriteToggle: _toggleFavorite,
        ),
      ];
    });
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
    _updateScreens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 1) {
              _updateScreens();
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppConstants.homeLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: AppConstants.favoritesLabel,
          ),
        ],
      ),
    );
  }
}
