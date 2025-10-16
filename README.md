# 📦 Catalog System (Flutter & Angular)

Monorepo containing:

- **Flutter App (Creator)** — Used to create and manage catalog items.
- **Angular Web App (Admin)** — Used to review, filter, and approve catalog items.

---

## ⚙️ Setup

### 🐦 Flutter App

```bash
# 1. Navigate to the Flutter project
cd flutter_app

# 2. Install dependencies
flutter pub get
```

---

### 🅰️ Angular App

```bash
# 1. Navigate to the Angular project
cd angular_app

# 2. Install dependencies
npm install
```

---

## 🚀 Run

### 🖥️ Start the Flutter Server

From the **root** of the monorepo:

```bash
dart run flutter_app/lib/Server/api_server.dart
```

Or from inside the `flutter_app` folder:

```bash
cd flutter_app
dart run lib/Server/api_server.dart
```

You should see the following message in the terminal:

```
✅ API Server running at http://<your-IP>:8080
```

---

### 📱 Run the Flutter App

```bash
cd flutter_app
flutter run
```

Then, in the terminal, select the platform (Android, iOS, or Web) where you want to run the app.

---

### 🌐 Run the Angular Admin Panel

```bash
cd angular_app
ng serve
```

After it compiles successfully, the app will be available at:  
👉 [http://localhost:4200/admin](http://localhost:4200/admin)

---

## 📖 User Guide

### 📲 Flutter App (Creator)

- When the app starts, you'll see a list of preloaded items for quick testing.
- Tap the **floating action button** in the bottom-right corner to open the **item creation view**.
- Fill in the fields and press **"Create Item"** to add a new one.
- A **snackbar** will appear confirming whether the operation succeeded or failed.
- After creation, the form fields reset automatically so you can keep adding more items.
- Use the **back arrow** in the app bar to return to the item list.
- The list updates automatically with new items.  
  If needed, you can **pull down to refresh** and fetch the latest data from the server — for example, to see changes made from the admin panel.

---

### 💻 Angular App (Admin)

- The main view displays the **list of catalog items** along with several filtering options.
- You can:

  - 🔍 Search items by **title** using the search bar.
  - 🗂️ Filter items by **category**.
  - 📊 Sort items **ascending or descending** by _Quality Score_.
  - 🔄 Click the **refresh button** to reload data from the server.

- Click on an item to open its **detail card**, where you can see all its information and, if it meets the requirements, **approve** it.
- If the item does **not** meet the quality standards or is already approved, an informative message will appear instead.
- Once you click the **Approve** button, both the card and the item list will update automatically to reflect the new state.

---

## 🧠 Notes

- Make sure both the Flutter server and the Angular admin are running simultaneously.
- The Flutter app communicates with the API server locally using the IP shown in the terminal.
- You can change the API endpoint in the configuration file if needed.

---

## 🧩 Tech Stack

- **Flutter 3.x**
- **Dart**
- **Angular 18+**
- **TypeScript**
- **GetX (State Management)**

---

✨ _Developed with passion for creating, learning, and productivity._
