# Product Catalog App

A Flutter mobile application that displays a list of products from a mock API, allows users to view product details, and manage favorites.

## Features

- Browse products with images, titles, and prices
- View detailed product information
- Add/remove products to favorites
- Persistent storage of favorites and product data
- Pull-to-refresh functionality
- Bottom navigation for easy access to Home and Favorites

## Packages Used

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0        # For making API requests
  shared_preferences: ^2.2.0  # For local data persistence
```

## Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/product_catalog_app.git
   cd product_catalog_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── crud_operations/
│   └── data_service_operations.dart  # Data persistence logic
├── model/
│   └── catalog_model.dart           # Product data model
├── screen/
│   ├── home_screen.dart             # Main product list
│   ├── product_detail_screen.dart   # Product details view
│   └── favourites_screen.dart       # Favorites list
└── main.dart                        # App entry point
```

## State Management

The app uses Flutter's built-in `setState` for state management with the following approach:

1. **Local State Management**
   - Each screen manages its own state using `setState`
   - State includes loading indicators, error messages, and UI updates

2. **Data Persistence**
   - Uses `SharedPreferences` for storing:
     - Favorite product IDs
     - Product catalog data
   - Data persists across app restarts

3. **State Synchronization**
   - Parent widget (`MyHomePage`) manages shared state
   - Callbacks used to update state across screens
   - Favorites state synchronized between Home and Detail screens

## API Integration

The app uses the Fake Store API (https://fakestoreapi.com/products) to fetch product data:
- GET /products - Fetches all products
- Products include: id, title, price, description, category, and image

## Screenshots

[Add screenshots of your app here]

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details
