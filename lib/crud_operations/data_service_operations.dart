import 'package:shared_preferences/shared_preferences.dart';

class DataServiceOperations {


  Future<void> saveFavorites(List<String> item)async {
    final pref= await SharedPreferences.getInstance();
   await pref.setStringList('favorites',item);
   
  }

  Future<List<String>> getFavorites() async {
    final pref= await SharedPreferences.getInstance();
    List<String> favorites = pref.getStringList('favorites') ?? [];
    print('Loaded from favorites: $favorites');
    return favorites;
  }
}
