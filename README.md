# Energy Dashboard (Flutter Web)

A responsive, role-based renewable energy dashboard built using **Flutter Web**, integrating with the **EIA (U.S. Energy Information Administration)** API. The dashboard supports search, sorting, pagination, visual charts, and Firebase-based authentication.

---

## Features

### Authentication & Access Control

* Secure email/password authentication using **Firebase Auth**
* **Role-based access control** (admin / user)
* Firestore stores and checks user role at login

### Dashboard Features

* Fetches real-time renewable energy data from the **EIA v2 API**
* Search by year
* Filters by:
    * State (e.g., CA, TX, NY)
    * Energy Type (e.g., Solar, Wind, Crude Oil, Coal)
* Sorting:
    * By year, energy type, or state
* Charts:
    * Line chart using **fl\_chart** to show consumption trend
* Pagination with infinite scroll
* Admin-only feature section in UI

### Responsive UI
* Adaptive layout for wide and narrow screens
* Material Design elements using Flutter widgets

### Clean Architecture
* Controllers, models, services separated
* Reactive programming using **GetX**
* Modular file structure

### Performance & Security

* Lazy loading with `ScrollController`
* Firebase handles secure sessions and token management
* Safe API error handling with `try-catch` and Snackbar UI alerts

### Testing

* Unit test for DashboardController logic (e.g., filtering and sorting)

---

## 📃 Tech Stack

| Layer            | Technology                     |
| ---------------- | ------------------------------ |
| Frontend         | Flutter Web (Dart)             |
| State Management | GetX                           |
| Auth             | Firebase Auth                  |
| Database         | Firebase Firestore (for roles) |
| Charts           | fl\_chart                      |
| Testing          | Flutter Test (unit testing)    |
| Data Source      | EIA Open Data v2 API           |

---

## 📁 Folder Structure

```
lib/
├── main.dart
├── models/             # Data models
├── services/           # API service classes
├── controllers/        # GetX controllers
├── views/              # UI views (Login, Register, Dashboard)
├── app/                # Routing and constants
```

---

## 📆 Setup Instructions

### 1. Clone the Repo

```bash
git clone https://github.com/your-username/energy_dashboard_flutter.git
cd energy_dashboard_flutter
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

* Create a Firebase project
* Enable Email/Password authentication
* Create Firestore database (start in test mode for dev)
* Replace your `firebase_options.dart` or use `flutterfire configure`

### 4. Run the App

```bash
flutter run -d chrome
```

---

##  Credits

* Data from [EIA Open Data API](https://www.eia.gov/opendata/)
* Built using Flutter & Firebase


---

## ✨ Author

**Richa Sharma**
[Flutter Portfolio](https://richie28-ai.github.io/my_portfolio/)
