# TaskMaster App

TaskMaster is a simple yet smart Flutter task management app designed for productivity. It combines user authentication, task tracking, counters, and API integration — all in one clean app.

## Features

- 🔐 **Login & Signup with Firebase Authentication**
- 🏠 **Home Menu** to navigate easily
- 📝 **To-Do List** with persistent storage using `shared_preferences`
- 🔢 **Counter** with Save and Reset, also backed by `shared_preferences`
- 📋 **User List** fetched via API
- 👤 **Profile Screen** with dummy profile image, name, and email
- ☁️ **Cloud Firestore** for storing user data (name, email, UID)
- 🧠 **State management with Provider** for tasks and user data

## Screens

### 🔐 Login Screen
- UI for entering email and password
- Connected to Firebase Authentication
- Clean and user-friendly layout

### 📝 Signup Screen
- Create a new account
- Stores user data in Firebase Authentication & Firestore
- Uses dummy profile image for simplicity

### 🏠 Home Menu
- Choose between:
  - To-Do List
  - Counter
  - API User List
  - Profile

### 🧾 To-Do List
- Add tasks using ➕ button
- Delete tasks
- Check off completed tasks
- Uses `shared_preferences` for local persistence
- Now uses **Provider** for real-time updates and smooth animations

### 🔢 Counter
- Increment / Decrement values
- Save and load values from `shared_preferences`
- Reset or delete saved value
- Real-time UI with Provider support

### 🌐 API User List
- Fetches dummy users from a REST API
- Displays name, email, and dummy profile pictures
- Integrated cleanly into UI

### 👤 Profile Screen
- Displays:
  - User name
  - Email
  - Dummy profile image
- Data fetched from Firebase & Provider


## Tech Stack

- **Flutter** 💙
- **Dart**
- **Firebase Authentication**
- **Cloud Firestore**
- **shared_preferences**
- **Provider**
- **REST API (for user list)**
- **VS Code / Android Studio**
