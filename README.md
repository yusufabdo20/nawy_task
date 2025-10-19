<img width="330" height="733" alt="image" src="https://github.com/user-attachments/assets/60499c4a-f3f3-4127-9cb0-8fd23f8c6575" /># nawy_task

A Flutter project.

## Getting Started

Nawy Task  by Yusuf Abdulfattah +201067869584 yusufafatah@gmail.com

A sleek, modern Flutter application for discovering and managing real estate properties.
Designed with clean architecture, powerful search capabilities, and a delightful user experience.

smart Property Search

Search by area name, compound name, or developer

Use advanced filters (price range, bedrooms, property type, etc.)

Fetch real-time filter options from the API

Instant, debounced search with loading indicators

View detailed information about each property
<img width="330" height="733" alt="image" src="https://github.com/user-attachments/assets/f6a726af-ce74-450d-a5fe-6958f6837fe1" />
<img width="330" height="733" alt="image" src="https://github.com/user-attachments/assets/e17ac1d0-89e4-4867-8b6f-8160ab9da837" />



--------------------------------------------------------------
Favorites

Save compounds or properties you like

Access your favorites anytime from a dedicated screen

Real-time sync across screens

Favorites persist even after restarting the app
--------------------------------------------------------------
Internationalization

Supports English and Arabic

RTL layout support for Arabic users

Simple language toggle for instant switch

All strings are fully localized
--------------------------------------------------------------
Performance 

Efficient BLoC state management

CachedNetworkImage for optimized image loading

Smart lazy loading and pagination

Optimized widget rebuilds and rendering
--------------------------------------------------------------
Pattern

Clean Architecture → clear separation between data, domain, and presentation

BLoC Pattern → predictable and testable state management

Repository Pattern → consistent data access layer

Dependency Injection via GetIt

--------------------------------------------------------------
Clone the repository

git clone <repository-url>
cd nawy_task


Install dependencies

flutter pub get


Run the app

flutter run
--------------------------------------------------------------

Feature Breakdown
1️⃣ Property Search

Responsive search interface with filters

API-driven filter options (price, rooms, etc.)

Paginated results with smooth loading

Debounced API calls for performance

2️⃣ Property Cards

Displays property image, price, area, and key info

Developer branding and quick details

Add/remove from favorites instantly

Tap to navigate to full details

3️⃣ Favorites

Persistent local storage using SharedPreferences

Real-time updates across all pages

Clear-all and quick toggle support

Favorite count badge in bottom navigation

4️⃣ Navigation

Intuitive bottom navigation for Explore / Favorites / More

Efficient IndexedStack navigation

Ready for deep linking

5️⃣ Theme System

Consistent color palette (Nawy branding)

Responsive and accessible text styles

Adaptive spacing and padding for all screens

--------------------------------------------------------------
Thank you 😊
