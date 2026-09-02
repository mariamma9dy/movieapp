# ToonBox 

ToonBox is a Flutter movie application focused on animation movies.
The app allows users to discover, search, view details, save favourites, and create a personal movie list.

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
  * Data persistence using Hive

* Other Features

  * Pull to refresh
  * Bottom navigation
  * Profile screen
  * Native splash screen
  * Loading and error states

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

```text
UI
 ↓
Controller
 ↓
Service
```

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

The application loads the saved movies when the Home screen starts.

## Authentication

Firebase Authentication is used for user registration, login, logout, and checking the current authentication state.

## How to Run

1. Clone the repository.
2. Open the project in VS Code or Android Studio.
3. Run:

```bash
flutter pub get
```

4. Create a `.env` file and add the TMDB access token:

```text
TMDB_ACCESS_TOKEN=your_token
```

5. Run the application:

```bash
flutter run
```

## Author

Mariam
