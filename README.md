# 🛡️ Secured Task Manager
** Udochukwu Ukasoanya — Senior Flutter Developer**

A secure, feature-rich task management app built with **Flutter** and **Firebase**, focused on user data protection, encrypted storage, and real-time synchronization.  
This project demonstrates modular architecture, authentication, and professional-grade Flutter practices for production apps.

---

## 🚀 Live Demo
> (Add your links once deployed)

- **Web:** https://[your-username].github.io/secured-task-manager/  
- **Android APK:** [link to APK or Drive]  
- **GitHub Repo:** https://github.com/[your-username]/secured-task-manager  

---

## 🧩 Overview
Secured Task Manager is designed to help users securely manage their daily tasks and track productivity.  
The app uses **Firebase Authentication** for secure logins, **Cloud Firestore** for real-time task syncing, and local **encryption** for sensitive data storage.  

It features task archiving, offline persistence, biometric security, and a clean, responsive UI built for both mobile and web.

---

## ✨ Features
- 🔐 **Secure Authentication** — Firebase Auth (email/password, biometrics)
- 🧱 **Data Protection** — Encrypted storage of sensitive data
- 🗂️ **Strategic Archived Tasks** — Archive, restore, or permanently delete
- 🔄 **Real-Time Sync** — Cloud Firestore with offline persistence
- 🌓 **Theming Support** — Light/dark mode with dynamic switching
- 🔔 **Notifications** — Push or local notifications (optional)
- 📱 **Responsive UI** — Optimized for mobile and web
- 🧠 **Clean Architecture** — Modular, testable, and scalable
- ⚙️ **CI/CD Ready** — Structured for automated build and deployment

---

## 🧱 Tech Stack
| Layer | Technology |
|-------|-------------|
| Frontend | Flutter (Dart) |
| Backend | Firebase (Auth, Firestore, Hosting, Messaging) |
| Security | flutter_secure_storage / AES encryption |
| State Management | Provider / Riverpod / Bloc (as configured) |
| Design | Material 3, Responsive Layout |
| Testing | flutter_test, mockito |
| CI/CD | GitHub Actions (optional) |

---

## 🗂️ Repo Structure
```bash
secure_task_manager/
│
├── android/                       # Native Android project files
├── ios/                           # Native iOS project files
├── linux/                         # Linux platform files
├── macos/                         # macOS platform files
├── web/                           # Flutter web entrypoint and assets
├── windows/                       # Windows platform files
│
├── assets/                        # App assets (icons, images, fonts)
│
├── lib/                           # Main Flutter source directory
│   ├── core/                      # Core utilities, constants, themes
│   │   └── ...                    # (e.g., constants, utils, theme setup)
│   │
│   ├── features/                  # Feature-based modules
│   │   ├── auth/                  # Authentication module
│   │   │   ├── data/              # Data sources (Firebase, models)
│   │   │   └── presentation/      # UI for auth (login, signup, etc.)
│   │   │
│   │   ├── onboarding/            # Onboarding flow
│   │   │   └── presentation/
│   │   │       └── onboarding_page.dart
│   │   │
│   │   ├── splash/                # Splash screen feature
│   │   │   └── presentation/
│   │   │       └── splash_screen.dart
│   │   │
│   │   └── task/                  # Core task management feature
│   │       ├── data/              # Task data & repositories
│   │       ├── domain/            # Domain models & use cases
│   │       └── presentation/      # UI and logic (Dashboard, etc.)
│   │           ├── biometric_guard.dart
│   │           ├── dashboard_page.dart
│   │           ├── edit_task_sheet.dart
│   │           └── tasks_page.dart
│   │
│   ├── router/                    # App routes & navigation
│   │   └── app_router.dart
│   │
│   ├── theme/                     # App theming and style management
│   │   ├── app_theme.dart
│   │   └── theme_provider.dart
│   │
│   ├── app.dart                   # Root widget and configuration
│   ├── main.dart                  # Entry point for app startup
│   └── firebase_options.dart      # Auto-generated Firebase config
│
├── test/                          # Unit & widget tests
│   └── ...                        # (e.g., widget_test.dart)
│
├── .env                           # Environment variables
├── .gitignore                     # Git ignore rules
├── firebase.json                  # Firebase hosting config
├── pubspec.yaml                   # Dependencies & assets
├── pubspec.lock                   # Locked dependencies
├── README.md                      # Project documentation
├── secure_task_manager.iml        # IntelliJ/Android Studio project file
└── .metadata                      # Flutter metadata
