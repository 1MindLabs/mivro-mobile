# Mivro Flutter App

This is the cross-platform mobile application for the Mivro project, built with the Flutter framework. It enables users to scan barcodes, search products, track meals, chat with a recipe chatbot, and explore a marketplace for healthier alternatives.

**Maintained By**: [Rishi Chirchi](https://github.com/rishichirchi)

-----

## Repository Structure

### Configuration and Metadata

  * **`.metadata`**: Contains metadata for the Flutter project.
  * **`analysis_options.yaml`**: Defines the linting rules and analysis options for the Dart code.
  * **`pubspec.lock`**: Locks the versions of dependencies used in the project.
  * **`pubspec.yaml`**: Specifies the app’s dependencies, assets, and other configurations.

### Platform-Specific Directories

  * **`android/`**: Contains files and configurations for building the Flutter app on Android.
  * **`ios/`**: Contains files and configurations for building the Flutter app on iOS.
  * **`linux/`**: Contains files and configurations for building the Flutter app on Linux.
  * **`macos/`**: Contains files and configurations for building the Flutter app on macOS.
  * **`web/`**: Contains files and configurations for building the Flutter app for the web.
  * **`windows/`**: Contains files and configurations for building the Flutter app on Windows.

### Assets

  * **`assets/`**: Contains animations for the scanner and icons/logos used in the user interface.

### Main Application Code (`lib/`)

  * **`providers/`**:
      * **`chat_history_provider.dart`**: Manages loading and maintaining the chat history.
      * **`chat_provider.dart`**: Handles API requests to the Python server for chatbot functionalities.
  * **`screens/`**:
      * **`home_page.dart`**: The main landing page of the app.
      * **`scanner_screen.dart`**: Manages the UI for the barcode scanner feature.
      * **`marketplace_screen.dart`**: Allows users to browse and purchase healthier product alternatives.
      * **`chat_screen.dart`**: Contains the interface for chatting with the recipe chatbot.
      * **`tracker_screen.dart`**: Handles the meal tracker functionality, allowing users to monitor their daily nutritional intake.
      * **`profile_screen.dart`**: Manages user profile details and settings.
  * **`main.dart`**: The entry point for the Flutter application, setting up the app structure and initial routes.

-----

## 🛠️ Requirements

Ensure you have the following installed:

  * **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install)
  * **Dart SDK** (comes with Flutter)
  * **Git** (for version control)
  * **Android Studio** or **VS Code** (with Flutter and Dart plugins)
  * \[Optional] **Xcode** (for iOS development on macOS)

To verify your environment setup, run:

```bash
flutter doctor
```

-----

## 📦 Installation Steps

### 1\. Clone the Repository

```bash
git clone https://github.com/your-username/your-flutter-project.git
cd your-flutter-project
```

### 2\. Get Dependencies

```bash
flutter pub get
```

-----

## 🔧 Configuration (if applicable)

### Firebase (Optional)

If using Firebase:

  * Place `google-services.json` in `android/app/`
  * Place `GoogleService-Info.plist` in `ios/Runner/`

### Environment Variables (Optional)

If your app uses environment variables:

  * Create a `.env` file in the root directory.

Example contents:

```env
API_KEY=your_api_key
BASE_URL=https://api.example.com
```

-----

## 📱 Running the App

### ➤ On a Real Device

#### Android

1.  Enable **Developer Options** on your Android phone.
2.  Enable **USB Debugging** under Developer Options.
3.  Connect the phone via USB.
4.  Verify the device is detected:
    ```bash
    flutter devices
    ```
5.  Run the app:
    ```bash
    flutter run
    ```
    You may have to authorize the PC when prompted on your phone.

#### iOS (macOS only)

1.  Connect your iPhone.
2.  Trust the computer from the iPhone.
3.  Open `ios/Runner.xcworkspace` in Xcode.
4.  Set your team ID under **Signing & Capabilities**.
5.  Run:
    ```bash
    flutter run
    ```

### ➤ On an Emulator

#### Android Emulator

1.  Open Android Studio \> **Device Manager**.
2.  Create a new virtual device with preferred specs.
3.  Start the emulator.
4.  Run:
    ```bash
    flutter run
    ```

#### iOS Simulator (macOS only)

1.  Open Simulator from Xcode (Xcode \> Open Developer Tool \> Simulator).
2.  Run:
    ```bash
    flutter run
    ```

-----

## 🧪 Running Tests

```bash
flutter test
```

-----

## 🧼 Cleaning the Project

```bash
flutter clean
flutter pub get
```

-----

## 📁 Project Structure

```css
lib/
├── main.dart
├── screens/
├── widgets/
├── models/
├── providers/
```

-----

## 📦 Build for Release

### Android (APK)

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

-----

## 🧩 Common Issues

### Android license not accepted

```bash
flutter doctor --android-licenses
```

### Xcode build fails

  * Ensure CocoaPods is installed: `sudo gem install cocoapods`
  * Open project in Xcode and resolve signing issues

### Device not detected

  * Ensure USB debugging is enabled
  * Use `flutter doctor -v` for detailed info

-----

## 🙌 Contributions

Contributions are welcome\! Please open an issue or submit a pull request.

-----

## 📄 License

This project is licensed under the MIT License.

-----

## Acknowledgments

  * [Open Food Facts](https://world.openfoodfacts.org) for providing access to a comprehensive food product database.
  * [All Contributors](https://github.com/Mivro/flutter-app/graphs/contributors) for their valuable contributions to the development and improvement of this project.
