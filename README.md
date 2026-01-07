🧩 Product Dashboard – Flutter Web

A modern, responsive Product Management Dashboard built with Flutter Web and BLoC/Cubit.This project was developed as part of a technical assessment to demonstrate clean architecture, scalable state management, and thoughtful UI/UX design for web applications.

🌐 Live Demo:https://product-dashboard-5b965.web.app

📂 GitHub Repository:https://github.com/MurtazaFlutter/Product-Dashboard

🎯 Project Overview

The Product Dashboard allows users to manage product inventory efficiently. It focuses on:

* Clear data presentation
* Smooth navigation
* Reactive state updates
* A clean and maintainable codebase

The application is fully responsive and works well on both desktop and smaller screens.

✨ Key Features

* 📋 Product List DashboardView products in a responsive table with sorting and pagination
* 🔍 Search & FiltersSearch products in real time and filter by category or stock status
* ➕ Add / Edit ProductsReusable modal form with validation and reactive updates via BLoC
* 📄 Product Details PageDedicated page with full product information and edit option
* 🌓 Light / Dark ThemeUser-friendly theme toggle using Material 3
* 🧭 Web NavigationImplemented with go_router for clean, scalable routing

🚀 How to Run the Project

Requirements

* Flutter 3.38.2+
* Dart 3.10.0+
* Chrome browser

Steps
git clone https://github.com/MurtazaFlutter/Product-Dashboard.git
cd Product-Dashboard
flutter pub get
flutter run -d chrome
To build for production:
flutter build web

🏗️ Architecture & Folder Structure
This project follows Clean Architecture with a feature-based structure, making it easy to scale and maintain.

lib/
 ├── core/                # Shared logic (theme, routing, constants)
 ├── features/
 │   ├── auth/            # Mock authentication
 │   ├── product/         # Product feature (data, domain, UI)
 │   └── theme/           # Theme management
 └── main.dart

Why this approach?
* Clear separation of concerns
* Business logic isolated from UI
* Easy to extend with new features
* Ideal for team-based development

🧠 State Management
* BLoC / Cubit is used across the app
* Handles fetching, searching, filtering, adding, editing, and deleting products
* Ensures predictable and testable state transitions

📚 Libraries & Tools Used
* flutter_bloc – State management
* go_router – Web routing
* http – API integration
* equatable – State comparison
* firebase_core – Firebase setup
* material – Material Design 3 UI

🌟 Bonus Features Implemented
* Pagination & sortable columns
* Light/Dark theme switcher
* Mock authentication flow
* Firebase Hosting deployment

📤 Submission Checklist
* ✅ Completed within the given timeframe
* ✅ Uses BLoC/Cubit (no Provider / GetX)
* ✅ Clean, modular folder structure
* ✅ Responsive Flutter Web UI
* ✅ GitHub repository shared
* ✅ Live demo deployed

👤 About the Developer
Ghulam Murtaza Developer with a focus on clean architecture, scalable state management, and polished user experiences.
If you’d like a walkthrough of the codebase or have any questions, feel free to reach out.Thank you for reviewing my submission!
