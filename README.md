# Mivro Flutter App

This is the cross-platform mobile application for the Mivro project, built with the Flutter framework. It enables users to scan barcodes, search products, track meals, chat with a recipe chatbot, and explore a marketplace for healthier alternatives.

**Maintained By**: [Rishi Chirchi](https://github.com/rishichirchi)

## Repository Structure

### Configuration and Metadata

- **`.metadata`**: Contains metadata for the Flutter project.
- **`analysis_options.yaml`**: Defines the linting rules and analysis options for the Dart code.
- **`pubspec.lock`**: Locks the versions of dependencies used in the project.
- **`pubspec.yaml`**: Specifies the app’s dependencies, assets, and other configurations.

### Platform-Specific Directories

- **`android/`**: Contains files and configurations for building the Flutter app on Android.
- **`ios/`**: Contains files and configurations for building the Flutter app on iOS.
- **`linux/`**: Contains files and configurations for building the Flutter app on Linux.
- **`macos/`**: Contains files and configurations for building the Flutter app on macOS.
- **`web/`**: Contains files and configurations for building the Flutter app for the web.
- **`windows/`**: Contains files and configurations for building the Flutter app on Windows.

### Assets

- **`assets/`**: Contains animations for the scanner and icons/logos used in the user interface.

### Main Application Code (`lib/`)

- **`core/`**: Shared utilities and configurations

  - **`api_constants.dart`**: API endpoints and base URLs
  - **`constants.dart`**: App-wide constants and theme configurations
  - **`hexcolor.dart`**: Color utility helpers

- **`features/`**: Feature modules organized by functionality

  - **`auth/`**: Authentication and user management

    - models/: User and personal details data models
    - providers/: Riverpod state management (user details, personal details)
    - screens/: Login, signup, and details screens
    - services/: Authentication API services

  - **`chat/`**: Recipe chatbot functionality

    - models/: Message data models
    - providers/: Chat state management (chat history, chat provider)
    - screens/: Chat interface
    - widgets/: Chat message components

  - **`home/`**: Main dashboard and product scanning

    - providers/: Product details state management
    - screens/: Home page and scanner screens
    - widgets/: Barcode scanner components and UI widgets

  - **`marketplace/`**: Product marketplace for healthier alternatives

    - models/: Product and cart data models
    - providers/: Cart state management
    - screens/: Marketplace and product purchase screens

  - **`profile/`**: User profile management

    - screens/: Profile and settings screens
    - services/: Profile API services

  - **`tracker/`**: Meal and nutrition tracking
    - screens/: Daily nutrition tracker interface

- **`main.dart`**: The entry point for the Flutter application, initializes Riverpod and sets up routing

## Getting Started

Follow these steps to set up and run the Mivro Flutter App on your local machine, or you can watch the [demo video](https://youtube.com/watch?v=ToXUq-NSkUg).

### Prerequisites

Ensure you have the following installed:

- **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (comes with Flutter)
- **Git** (for version control)
- **Android Studio** or **VS Code** (with Flutter and Dart plugins)
- \[Optional] **Xcode** (for iOS development on macOS)

To verify your environment setup, run:

```bash
flutter doctor
```

### Installation

1. **Fork the Repository**:

   - Go to the [Mivro Flutter App repository](https://github.com/1MindLabs/mivro-mobile) and click "Fork" to create a copy under your GitHub account.

2. **Clone the Repository**:

   ```bash
   git clone https://github.com/<your-username>/mivro-mobile.git
   cd mivro-mobile
   ```

3. **Get Dependencies**:

   ```bash
   flutter pub get
   ```

## Usage

### Running on a Real Device

#### Android

1. Enable **Developer Options** on your Android phone.
2. Enable **USB Debugging** under Developer Options.
3. Connect the phone via USB.
4. Verify the device is detected:

   ```bash
   flutter devices
   ```

5. Run the app:

   ```bash
   flutter run
   ```

   You may have to authorize the PC when prompted on your phone.

#### iOS (macOS only)

1. Connect your iPhone.
2. Trust the computer from the iPhone.
3. Open `ios/Runner.xcworkspace` in Xcode.
4. Set your team ID under **Signing & Capabilities**.
5. Run:

   ```bash
   flutter run
   ```

### Running on an Emulator

#### Android Emulator

1. Open Android Studio > **Device Manager**.
2. Create a new virtual device with preferred specs.
3. Start the emulator.
4. Run:

   ```bash
   flutter run
   ```

#### iOS Simulator (macOS only)

1. Open Simulator from Xcode (Xcode > Open Developer Tool > Simulator).
2. Run:

   ```bash
   flutter run
   ```

## Build for Release

### Android (APK)

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

## Documentation

For detailed documentation, visit the [Documentation Repository](https://github.com/1MindLabs/mivro-documentation).

## Contributing

We welcome contributions! Follow the guidelines in our [Contributing Guide](https://github.com/1MindLabs/mivro-documentation/blob/main/CONTRIBUTING.md).

## Acknowledgments

- [Open Food Facts](https://world.openfoodfacts.org) for providing access to a comprehensive food product database.
- [All Contributors](https://github.com/Mivro/flutter-app/graphs/contributors) for their valuable contributions to the development and improvement of this project.
