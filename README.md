# Product Catalog App

A Flutter mobile application that displays a list of products from a mock API, allows users to view product details, and manage favorites.

# Download Link 

https://github.com/EedupugantiVenkatesh/store_app/releases/download/untagged-a0d8aea2a85ca9b3be74/app-release.apk

## Packages Used

  http: ^1.1.0       
  shared_preferences: ^2.2.0 

## Setup Instructions

1. **Clone the repository**
   git clone https://github.com/EedupugantiVenkatesh/store_app.git
   
   cd product_catalog_app

2. **Install dependencies**
   flutter pub get

3. **Run the app**
   flutter run


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
