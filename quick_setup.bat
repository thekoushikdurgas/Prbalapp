@echo off
setlocal enabledelayedexpansion

echo 🚀 Quick Prbal Flutter Setup for Windows
echo ==========================================

echo.
echo This script will:
echo 1. Clean previous builds
echo 2. Get Flutter dependencies  
echo 3. Validate app configuration
echo 4. Run code analysis
echo 5. Build and test the app

echo.
set /p "confirm=Do you want to continue? (Y/N): "
if /i not "%confirm%"=="Y" goto :end

echo.
echo 🧹 Step 1: Cleaning previous builds...
flutter clean >nul 2>&1
if exist "android" (
    cd android
    call gradlew clean >nul 2>&1
    cd ..
)
if exist "ios" (
    cd ios
    if exist "Podfile.lock" del /f "Podfile.lock" >nul 2>&1
    if exist "Pods" rmdir /s /q "Pods" >nul 2>&1
    cd ..
)

echo ✅ Clean completed

echo.
echo 📦 Step 2: Getting Flutter dependencies...
flutter pub get
if !errorlevel! == 0 (
    echo ✅ Dependencies downloaded successfully
) else (
    echo ❌ Failed to get dependencies
    goto :end
)

echo.
echo 🔧 Step 3: Installing iOS dependencies (if on macOS)...
if exist "ios\Podfile" (
    cd ios
    pod install --repo-update >nul 2>&1
    if !errorlevel! == 0 (
        echo ✅ iOS dependencies installed
    ) else (
        echo ⚠️ iOS dependencies installation failed or not on macOS
    )
    cd ..
) else (
    echo ℹ️ No iOS Podfile found, skipping iOS setup
)

echo.
echo 🔍 Step 4: Running Flutter analyze...
flutter analyze
if !errorlevel! == 0 (
    echo ✅ No analysis issues found
) else (
    echo ⚠️ Some analysis issues found - check output above
)

echo.
echo 📋 Step 5: Running Flutter doctor...
flutter doctor
echo ✅ Flutter doctor completed

echo.
echo 🏗️ Step 6: Building debug APK...
flutter build apk --debug --analyze-size
if !errorlevel! == 0 (
    echo ✅ Debug build successful
) else (
    echo ❌ Debug build failed
    echo Check the output above for errors
)

echo.
echo 📱 Step 7: Checking for connected devices...
adb devices | findstr "device" >nul
if !errorlevel! == 0 (
    echo ✅ Android device detected
    set /p "runOnDevice=Do you want to run the app on device? (Y/N): "
    if /i "!runOnDevice!"=="Y" (
        echo 🚀 Starting app on device...
        flutter run --debug
    )
) else (
    echo ⚠️ No Android device connected
    echo Connect a device and run: flutter run --debug
)

echo.
echo 🎉 Setup completed!
echo ===================

echo.
echo 📋 App Features:
echo - Authentication with custom backend API
echo - OTP/PIN verification system
echo - Service marketplace functionality
echo - Real-time location services
echo - Push notifications
echo - Theme switching (light/dark)
echo - Multi-language support

echo.
echo 🔧 Next steps:
echo 1. Connect an Android device or iOS simulator
echo 2. Run: flutter run --debug
echo 3. Test authentication flow
echo 4. Test service booking features
echo 5. Configure backend API endpoints

echo.
echo 📚 Useful commands:
echo - flutter run --debug          (Run in debug mode)
echo - flutter run --release        (Run in release mode)
echo - flutter build apk --release  (Build release APK)
echo - flutter build ios --release  (Build iOS app)
echo - adb logcat                   (View Android device logs)
echo - flutter logs                 (View Flutter logs)

:end
echo.
echo Press any key to exit...
pause >nul 