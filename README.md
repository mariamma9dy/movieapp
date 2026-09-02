# ToonBox

ToonBox is a Flutter movie application focused on animation movies.

The app allows users to discover, search, view movie details, save favourites, create a personal movie list, and keep track of recently viewed movies.

## Features

* Firebase Authentication
  * Register
  * Login
  * Logout
  * Authentication state check

* Animation Movies
  * Popular Animation Movies
  * Top Rated Animation Movies
  * New / Now Playing Animation Movies
  * Search Animation Movies

* Movie Details
  * Movie poster and backdrop
  * Rating
  * Release date
  * Original language
  * Runtime
  * Genres
  * Overview

* Local Storage
  * Favourites
  * My List
  * Recently Viewed
  * Data persistence using Hive

* Other Features
  * Pull to refresh
  * Bottom navigation
  * Profile screen
  * Recently Viewed movies
  * Native splash screen
  * Loading and error states
  * Empty states

## Technologies

* Flutter
* Dart
* Firebase Authentication
* TMDB API
* Provider
* Hive
* HTTP
* Flutter Dotenv

## Architecture

The project follows a simple layered architecture:


### UI

Responsible for displaying the interface and handling user interactions.

### Controller

Responsible for coordinating between the UI, Provider, and Services.

### Provider

Responsible for managing application state and notifying the UI when the state changes.

### Service

Responsible for communicating with external services such as Firebase, TMDB API, and Hive.

## Project Structure

```text
lib/

│
├── Controllers/
│   ├── FirebaseAuthController.dart
│   └── MovieController.dart
│
├── Models/
│   ├── MovieModel.dart
│   └── MovieDetailsModel.dart
│
├── Providers/
│   ├── FirebaseAuthProvider.dart
│   └── MovieProvider.dart
│
├── Services/
│   ├── FirebaseAuthService.dart
│   ├── HiveService.dart
│   └── TMDBService.dart
│
└── Views/
    ├── Screens/
    │   ├── SplashScreen.dart
    │   ├── LogInScreen.dart
    │   ├── RegisterScreen.dart
    │   ├── HomeScreen.dart
    │   ├── MovieDetailsScreen.dart
    │   ├── FavoritesScreen.dart
    │   ├── MyListScreen.dart
    │   ├── RecentlyViewedScreen.dart
    │   └── ProfileScreen.dart
    │
    └── Widgets/
```

## API

The application uses the TMDB API to retrieve movie data.

The TMDB access token is stored in a `.env` file instead of being hard-coded in the source code.

```text
TMDB_ACCESS_TOKEN=your_token
```

The `.env` file should not be committed to GitHub.

## Local Storage

Hive is used to store:

* Favourite movies
* Movies in My List
* Recently Viewed movies

The application loads the saved local data when the Home screen starts.

Recently Viewed keeps track of movies opened by the user and displays the recently viewed movies in the Profile section.

## Authentication

Firebase Authentication is used for:

* User registration
* User login
* User logout
* Checking the current authentication state
* Handling authentication errors


## How to Run

1. Clone the repository.

2. Open the project in VS Code or Android Studio.

3. Run:

```bash
flutter pub get
```

4. Create a `.env` file in the project root and add the TMDB access token:


TMDB_ACCESS_TOKEN=your_token


5. Run the application:

```bash
flutter run
```

## Known Limitations

* The application requires an internet connection to retrieve movie data from TMDB.
* Movie availability depends on the data provided by TMDB.
* Recently Viewed, Favourites, and My List are stored locally on the device using Hive.
* The application currently focuses on animation movies.

## Author

Mariam


