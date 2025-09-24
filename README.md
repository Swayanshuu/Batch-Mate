# Batch Mate
[![Flutter App](https://deepwiki.com/Swayanshuu/Batch-Mate)

Batch Mate is a Flutter-based mobile application designed to help students within a batch or class stay organized. It provides a centralized platform to manage assignments, timetables, and notices, ensuring that all class-related information is easily accessible.

## Features

-   **Google Authentication**: Secure and easy sign-in using Google accounts.
-   **Dashboard**: A central home screen providing a quick overview of the latest assignments, timetables, and notices.
-   **Assignment Tracking**: Add, view, edit, and delete assignments. Includes details like title, subject, due date, and description.
-   **Timetable Management**: Add and view daily or weekly timetables, detailing subjects, rooms, and times.
-   **Notice Board**: Post and view important announcements and notices for the entire batch.
-   **User Profiles**: View and edit your personal details, including your name and batch ID.
-   **Onboarding**: A smooth onboarding experience for new users to get acquainted with the app.

## Tech Stack

-   **Framework**: Flutter
-   **Language**: Dart
-   **Backend**: Firebase
    -   **Authentication**: Firebase Authentication for Google Sign-In.
    -   **Database**: Cloud Firestore for user management and Firebase Realtime Database for batch-specific data (assignments, timetables, notices).
-   **State Management**: Provider

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

-   Flutter SDK installed on your machine.
-   A code editor like VS Code or Android Studio.
-   A configured Firebase project.

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/Swayanshuu/Batch-Mate.git
    cd Batch-Mate
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```
3.  **Set up Firebase:**
    -   Create a new project on the [Firebase Console](https://console.firebase.google.com/).
    -   Add an Android and/or iOS app to your Firebase project.
    -   Follow the Firebase setup instructions to download the `google-services.json` file for Android and the `GoogleService-Info.plist` file for iOS.
    -   Place `google-services.json` in the `android/app/` directory.
    -   Place `GoogleService-Info.plist` in the `ios/Runner/` directory.
    -   Use the FlutterFire CLI to generate the `firebase_options.dart` file for your project:
        ```sh
        flutterfire configure
        ```
    -   Enable Google Sign-In as an authentication provider in your Firebase project.
    -   Set up Firestore and Realtime Database. For the Realtime Database, you can start with open read/write rules for development:
        ```json
        {
          "rules": {
            ".read": true,
            ".write": true
          }
        }
        ```

4.  **Run the application:**
    ```sh
    flutter run
    ```

## License

Distributed under the MIT License. See `LICENSE` for more information.
