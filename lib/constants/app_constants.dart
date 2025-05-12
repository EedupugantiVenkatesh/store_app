class AppConstants {
  // API URLs
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String productsEndpoint = '/products';

  // Storage Keys
  static const String favoritesKey = 'favorites';
  static const String storeItemsKey = 'store_items';

  // UI Strings
  static const String appTitle = 'Product Catalog';
  static const String homeTitle = 'Store';
  static const String favoritesTitle = 'Favorites';
  static const String productDetailsTitle = 'Product Details';
  static const String noFavoritesFound = 'No Favorites Found';
  static const String description = 'Description';
  static const String category = 'Category';
  static const String pricePrefix = '\$';
  static const String errorLoadingProducts = 'Failed to load products';
  static const String errorLoadingFavorites = 'Error loading favorites';
  static const String errorLoadingStoreItems = 'Error loading store items';

  // Navigation
  static const String homeLabel = 'Home';
  static const String favoritesLabel = 'Favorites';

  // Image Sizes
  static const double listImageSize = 50.0;
  static const double detailImageHeight = 300.0;
  static const double listImageSizeSmall = 30.0;

  // Text Lengths
  static const int maxTitleLength = 30;
  static const int maxNameLength = 10;

  // Padding
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;

  // Icons
  static const String favoriteIcon = 'favorite';
  static const String favoriteBorderIcon = 'favorite_border';
  static const String homeIcon = 'home';
  static const String favoriteNavIcon = 'favorite';
} 