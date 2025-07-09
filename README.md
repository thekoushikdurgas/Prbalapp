# Prbal - Service Marketplace App

A modern Flutter application for connecting service providers with customers, built with a clean architecture and custom backend integration.

## 🎯 Project Overview

Prbal is a comprehensive service marketplace app that facilitates seamless connections between service providers and customers. The app features real-time location services, secure authentication, and a intuitive user interface supporting both light and dark themes.

## ✨ Key Features

### 🔐 Authentication System
- **Custom Backend API**: Secure authentication without Firebase dependency
- **OTP Verification**: SMS-based one-time password verification
- **PIN Authentication**: Secondary security layer with PIN verification
- **Biometric Support**: Face ID/Touch ID integration on iOS

### 🏠 Core Functionality
- **Service Marketplace**: Browse and book various services
- **Real-time Location**: GPS-based service provider discovery
- **Push Notifications**: Custom notification system for updates
- **Multi-theme Support**: Light and dark theme switching
- **Internationalization**: Multi-language support with easy_localization
- **State Management**: Efficient state management with BLoC/Cubit and Riverpod

### 📱 User Experience
- **Modern UI**: Material Design 3 components
- **Responsive Design**: Optimized for various screen sizes
- **Smooth Navigation**: go_router for seamless navigation
- **Performance Optimized**: Enhanced with performance monitoring
- **Accessibility**: Full accessibility support

## 🏗️ Architecture

### Framework & Language
- **Flutter**: Cross-platform mobile development
- **Dart**: Programming language
- **Material Design 3**: UI components

### State Management
- **BLoC/Cubit**: Business logic components
- **Riverpod**: Provider-based state management
- **Hive**: Local data caching

### Backend Integration
- **Custom API**: RESTful API integration
- **HTTP Client**: Dio for network requests
- **Authentication**: JWT-based authentication
- **Real-time Updates**: WebSocket support

### Navigation & Routing
- **go_router**: Declarative routing
- **Deep Linking**: Custom URL scheme support
- **Universal Links**: iOS universal links support

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (2.17.0 or higher)
- Android Studio / VS Code
- Android SDK (API level 21+)
- Xcode (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/durgas/prbal-app.git
   cd prbal
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   ```bash
   # Copy environment configuration
   cp .env.example .env
   # Edit .env with your API endpoints
   ```

4. **Run the app**
   ```bash
   # Debug mode
   flutter run --debug
   
   # Release mode
   flutter run --release
   ```

### Quick Setup (Windows)
Run the provided batch script for automated setup:
```bash
./quick_setup.bat
```

## 🔧 Configuration

### API Configuration
Update the API endpoints in your environment configuration:
```dart
// lib/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://api.prbal.com';
  static const String authEndpoint = '/auth';
  static const String servicesEndpoint = '/services';
}
```

### Push Notifications
Configure push notification settings in the respective platform files:
- Android: `android/app/src/main/AndroidManifest.xml`
- iOS: `ios/Runner/Info.plist`

## 📱 Platform-Specific Setup

### Android
- **Minimum SDK**: API level 21 (Android 5.0)
- **Target SDK**: API level 34 (Android 14)
- **Permissions**: Location, Camera, Storage, Notifications
- **ProGuard**: Enabled for release builds

### iOS
- **Deployment Target**: iOS 12.0+
- **Permissions**: Location, Camera, Photos, Notifications
- **App Transport Security**: Configured for secure communications
- **Background Modes**: Location updates, Push notifications

## 🏃‍♂️ Build Commands

### Development
```bash
# Run in debug mode
flutter run --debug

# Run with specific flavor
flutter run --flavor development --debug
```

### Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Code coverage
flutter test --coverage
```

### Production Builds
```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS App
flutter build ios --release

# iOS Archive
flutter build ipa --release
```

## 📁 Project Structure

```
lib/
├── components/          # Reusable UI components
├── constants/           # App constants and configuration
├── extension/           # Dart extensions
├── init/               # App initialization
│   ├── cache/          # Cache management
│   ├── cubit/          # State management
│   ├── localization/   # i18n configuration
│   ├── navigation/     # Routing configuration
│   └── theme/          # Theme configuration
├── product/            # Business logic and models
├── services/           # API services and utilities
└── view/               # UI screens and pages
    ├── auth/           # Authentication screens
    ├── home/           # Home dashboard
    ├── introduction/   # Onboarding screens
    ├── settings/       # Settings screens
    ├── splash/         # Splash screen
    └── welcome/        # Welcome screens
```

## 🧪 Testing

### Unit Tests
```bash
flutter test test/unit/
```

### Integration Tests
```bash
flutter test integration_test/
```

### Widget Tests
```bash
flutter test test/widget/
```

## 📊 Performance Monitoring

The app includes built-in performance monitoring:
- **App Launch Time**: Tracks cold and warm start times
- **Network Requests**: Monitors API response times
- **Memory Usage**: Tracks memory consumption
- **User Interactions**: Measures UI responsiveness

## 🌍 Localization

Supported languages:
- English (en)
- Spanish (es)
- French (fr)
- German (de)
- Hindi (hi)
- Arabic (ar)

Add new translations in `assets/translations/`.

## 🎨 Theming

The app supports dynamic theming:
- **Light Theme**: Default Material Design 3 light theme
- **Dark Theme**: Custom dark theme with brand colors
- **System Theme**: Follows system theme preference

## 🔒 Security

### Data Protection
- **Encrypted Storage**: Sensitive data encrypted using Hive
- **Secure Communications**: TLS 1.2+ for all network requests
- **Authentication**: JWT-based authentication with refresh tokens
- **Biometric Security**: Native biometric authentication support

### Privacy
- **Data Minimization**: Collects only necessary user data
- **Privacy Controls**: User-controllable privacy settings
- **GDPR Compliance**: Fully compliant with privacy regulations

## 🚀 Deployment

### Android (Google Play Store)
1. Build app bundle: `flutter build appbundle --release`
2. Upload to Google Play Console
3. Configure store listing and pricing
4. Submit for review

### iOS (App Store)
1. Build iOS archive: `flutter build ipa --release`
2. Upload to App Store Connect
3. Configure app metadata
4. Submit for review

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENCE](LICENCE) file for details.

## 🙋‍♂️ Support

For support and questions:
- **Email**: support@durgas.com
- **Documentation**: [View Documentation](docs/)
- **Issues**: [GitHub Issues](https://github.com/durgas/prbal-app/issues)

## 🚀 Roadmap

### Upcoming Features
- **AI Integration**: Smart service recommendations
- **Voice Search**: Voice-powered service discovery
- **Augmented Reality**: AR-based service visualization
- **IoT Integration**: Smart device connectivity
- **Blockchain Payments**: Cryptocurrency payment support

---

**Built with ❤️ by Durgas Technologies**

---

*Last Updated: December 2024*
