import 'package:flutter/material.dart';

import 'model/catalog_model.dart';
import 'screen/favourites_screen.dart';
import 'screen/home_screen.dart';

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

  late List<Widget> _screens = [];

  void _onItemsLoaded(List<CategoryModel> items) {
    setState(() {
      storeItems = items;
      // Update FavouritesScreen with new items
      _screens = [
        HomeScreen(onItemsLoaded: _onItemsLoaded),
        FavouritesScreen(allItems2: storeItems)
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onItemsLoaded: _onItemsLoaded),
      FavouritesScreen(allItems2: storeItems)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            // Refresh FavouritesScreen when switching to it
            if (index == 1) {
              _screens[1] = FavouritesScreen(allItems2: storeItems);
            }
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
        ],
      ),
    );
  }
}
