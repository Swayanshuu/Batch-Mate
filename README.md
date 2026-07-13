# 🎓 Batch-Mate

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.8.1-blue?style=for-the-badge&logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-yellow?style=for-the-badge&logo=firebase)
![Provider](https://img.shields.io/badge/State%20Management-Provider-orange?style=for-the-badge)

Batch-Mate is a comprehensive classroom and batch management application built with **Flutter** and powered by **Firebase**. It provides an intuitive platform for students and educators to stay synced with their daily schedules, assignments, and important notices. 

Whether you need to check your timetable, track upcoming assignment deadlines, or get the latest class announcements, Batch-Mate provides a centralized hub to keep you organized.

---

## ✨ Key Features

- **🔒 Secure Authentication**: Seamless and secure Google Sign-In using Firebase Authentication.
- **🏠 Smart Dashboard**: A beautifully designed home screen providing a quick overview of the latest assignments, timetables, and important notices.
- **📚 Assignment Tracking**: Add, view, edit, and delete assignments. Keep track of subjects, descriptions, and crucial due dates.
- **📅 Timetable Management**: Stay on top of your classes. Add and view daily or weekly timetables, detailing subjects, rooms, and specific timings.
- **📢 Notice Board**: Broadcast and view important announcements and notices for the entire batch in real-time.
- **👤 User Profiles**: Manage personal details, batch IDs, and custom display names synchronized via Cloud Firestore.
- **🚀 Smooth Onboarding**: An intuitive onboarding flow for first-time users to get acquainted with the application's capabilities.
- **✨ Polished UI/UX**: Includes features like Shimmer effects (`shimmer_text`, `skeletonizer`) for smooth loading states and `animated_text_kit` for beautiful text reveals.

---

## 🏗️ Architecture & App Flow

The application follows a modular and scalable architecture. It separates the UI presentation layer from the business logic and state management using the **Provider** pattern, while data is synchronized in real-time with Firebase.

```mermaid
graph TD
    %% Styling
    classDef ui fill:#e3f2fd,stroke:#1e88e5,stroke-width:2px,color:#000
    classDef state fill:#fff3e0,stroke:#fb8c00,stroke-width:2px,color:#000
    classDef backend fill:#e8f5e9,stroke:#43a047,stroke-width:2px,color:#000
    classDef external fill:#fce4ec,stroke:#d81b60,stroke-width:2px,color:#000

    %% UI Layer
    subgraph "Presentation Layer (Flutter UI)"
        Splash["💧 Splash & Onboarding"]:::ui
        AuthUI["🔐 Auth Screens"]:::ui
        MainScreen["🏠 Main Dashboard"]:::ui
        ContentScreens["📑 Content Screens\n(Assignments, Notices, Timetable)"]:::ui
        Profile["👤 User Profile"]:::ui
    end

    %% State Management
    subgraph "State Management Layer"
        UserProv["📦 UserProvider\n(State & User Details)"]:::state
    end

    %% Service Layer
    subgraph "Service Layer"
        AuthService["🔑 Auth Service\n(Google Sign-In)"]:::state
        APIService["🌐 API Data Service"]:::state
    end

    %% Backend Layer
    subgraph "Backend Data Layer (Firebase)"
        FirebaseAuth["🔥 Firebase Auth"]:::backend
        Firestore["🗄️ Cloud Firestore\n(Users, Batches)"]:::backend
        RealtimeDB["⚡ Realtime Database\n(Real-time updates)"]:::backend
    end
    
    ExternalAPI["🌍 External REST APIs\n(via Dio)"]:::external

    %% Flow
    Splash --> AuthUI
    AuthUI -- Uses --> AuthService
    AuthService -- Authenticates --> FirebaseAuth
    AuthService -- Triggers --> MainScreen
    
    MainScreen --> ContentScreens
    MainScreen --> Profile
    
    MainScreen -- Listens to --> UserProv
    Profile -- Listens to --> UserProv
    ContentScreens -- Uses --> APIService
    
    UserProv -- Fetches/Updates --> Firestore
    APIService -- Real-time sync --> RealtimeDB
    APIService -.-> ExternalAPI
```

---

## 📂 Project Structure

```text
lib/
├── Animation/           # Custom UI animations and transitions
├── Provider/            # State management (e.g., userProvider.dart)
├── Screens/             # Core UI presentation layer
│   ├── On-Boarding Screen/ # App intro and setup
│   ├── Services/        # Backend connectors (Auth, APIs)
│   ├── User Profile/    # Profile management UI
│   ├── contentScreens/  # Feature modules (Assignment, Notice, Timetable)
│   ├── main_Screen.dart # Dashboard shell & navigation
│   └── splash_Screen.dart # Initial launch screen
├── components/          # Reusable structural widgets
├── customs/             # Custom built widgets (e.g., textField.dart)
├── firebase_options.dart # Firebase initialization configuration
└── main.dart            # Application entry point
```

---

## 🛠️ Tech Stack & Dependencies

- **Framework**: Flutter (SDK ^3.8.1)
- **Language**: Dart
- **State Management**: `provider` (^6.1.5)
- **Backend & Services**: 
  - `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_analytics`
  - `google_sign_in` (OAuth 2.0 Integration)
- **Networking**: `dio` (^5.9.0) for external API communication.
- **UI Enhancements**: 
  - `skeletonizer` & `shimmer_text` (Loading placeholders)
  - `animated_text_kit` & `smooth_page_indicator`
  - `font_awesome_flutter` & `cupertino_icons`

---

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- Install the [Flutter SDK](https://flutter.dev/docs/get-started/install).
- A Firebase project configured for Android, iOS, or Web.
- Visual Studio Code or Android Studio with Flutter extensions.

### Installation

1. **Clone the repository**
   ```sh
   git clone https://github.com/your-username/batch-mate.git
   cd batch-mate
   ```

2. **Install Flutter packages**
   ```sh
   flutter pub get
   ```

3. **Configure Firebase**
   - Ensure you have the Firebase CLI installed (`npm install -g firebase-tools`).
   - Run `flutterfire configure` to generate/update the `lib/firebase_options.dart` file based on your Firebase project.

4. **Run the App**
   ```sh
   flutter run
   ```

---

## 🛡️ License

Distributed under the MIT License. See `LICENSE` for more information.
