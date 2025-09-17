# 🚖 Driver App (Travels App)

A complete Flutter-based **Driver Fleet Management App** that helps drivers manage their trips, fuel logs, bonuses, and profile — all in one place.  

This app is designed for travel companies and fleets to provide drivers with a simple, modern dashboard and features to track their work efficiently.

---

## 📱 Features

✅ **Home Dashboard**  
- Welcome screen with driver name and trip status  
- Today's trip summary (distance, route, ETA)  
- Quick actions for Fuel Entry, Bonus View, Trip Photo upload  

✅ **Trips Management**  
- View upcoming and past trips  
- Start/End trips with one-tap access  
- Add journey feedback after completing a trip  

✅ **Fuel & Vehicle Management**  
- Log fuel entries with odometer reading  
- View past fuel logs and expenses  
- Get alerts for low fuel or maintenance  

✅ **Bonus System**  
- Dynamic bonuses (attendance, performance, safety)  
- View total bonus and history  

✅ **Profile Management**  
- Edit personal details (name, phone, address)  
- Upload and update driver profile picture  
- View and upload necessary documents (license, insurance)

✅ **Modern UI & UX**  
- Clean Material 3 design  
- Dark/Light mode support  
- Smooth animations  

---

## 🛠️ Tech Stack

- **Flutter** – Cross-platform UI framework  
- **Dart** – Programming language  
- **Provider** – State management  
- **Firebase** *(optional, for backend)* – For storing trips, fuel logs, and uploaded documents  

---

## 📂 Project Structure

lib/
┣ 📁 models/ # Data models (Driver, Trip, Bonus, etc.)
┣ 📁 providers/ # State management with Provider
┣ 📁 screens/ # UI Screens (Home, Trips, FuelEntry, Profile)
┣ 📁 widgets/ # Reusable widgets (cards, buttons)
┗ main.dart # Entry point

---

## 🚀 Getting Started

### Prerequisites
- Install [Flutter](https://flutter.dev/docs/get-started/install)
- Android Studio or VS Code
- GitHub account for version control
- (Optional) Firebase project if connecting backend

### Run Locally
```bash
# Clone the repository
git clone https://github.com/Varunannabeemoju123/driver_app.git

# Navigate to project
cd driver_app

# Get dependencies
flutter pub get

# Run the app
flutter run

##👨‍💻 Author

Varun Annabeemoju



---

You can copy this content into a new file in your project root:

1. In Android Studio → Right-click project root → `New` → `File`
2. Name it `README.md`
3. Paste this content
4. Stage, commit, and push:

```bash
git add README.md
git commit -m "Add README"
git push
