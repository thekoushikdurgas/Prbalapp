# 🚀 Backend API Integration Guide for Prbal App

## ✅ **What's Been Implemented**

### **1. Core API Infrastructure**

- `lib/services/api_service.dart` - Base HTTP client with error handling
- `lib/services/app_services.dart` - Centralized service providers
- `lib/services/service_management_service.dart` - Service & booking management

### **2. Authentication Service**

- Updated `lib/services/auth_service.dart` with full backend integration
- User registration (customer, provider, admin)
- PIN-based authentication
- Token management with automatic refresh
- Profile management

### **3. Local Storage Enhancement**

- Enhanced `lib/services/hive_service.dart` with token storage
- Automatic session persistence
- Secure logout functionality

### **4. Service Management**

- Service CRUD operations
- Booking management
- Category and featured services
- Provider-specific endpoints

## 🔧 **Integration Steps**

### **Step 1: Update main.dart**

Replace your current `main.dart` with:

```dart
import 'package:prbal/app.dart';
import 'package:prbal/init/cache/onboarding/intro_caching.dart';
import 'package:prbal/init/cubit/theme_cubit.dart';
import 'package:prbal/init/cache/theme/theme_caching.dart';
import 'package:prbal/init/localization/project_locales.dart';
import 'package:prbal/cubit_observer.dart';
import 'package:prbal/services/app_services.dart'; // Add this import
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'init/localization/localization.dart';

Future<void> main() async {
  await LocaleVariables._init();
  await ThemeCaching.init();
  await IntroCaching.init();
  
  // Initialize app services (includes HiveService.init())
  await AppServices.initialize();
  
  Bloc.observer = CubitObserver();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: LocaleVariables._localesList,
        path: LocaleVariables._localesPath,
        fallbackLocale: LocaleVariables._fallBackLocale,
        child: BlocProvider(
          create: (context) => ThemeCubit(),
          child: const MyApp(),
        ),
      ),
    ),
  );
}
```

### **Step 2: Update API Configuration**

In `lib/services/api_service.dart`, update the baseUrl:

```dart
class ApiConfig {
  // Change this to your actual backend URL
  static const String baseUrl = 'https://your-api-domain.com'; // or 'http://localhost:8000' for local development
  static const String apiVersion = 'v1';
  // ... rest remains the same
}
```

### **Step 3: Authentication Integration**

#### **Registration Screen durgas:**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbal/services/app_services.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authProvider.notifier);
      
      final response = await authService.registerAsCustomer(
        username: _usernameController.text,
        email: _emailController.text,
      );

      if (response.success) {
        // Registration successful, user is now logged in
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Registration failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleRegistration,
              child: _isLoading 
                ? CircularProgressIndicator() 
                : Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### **Login Screen durgas:**

```dart
class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _pinController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authProvider.notifier);
      
      final response = await authService.loginWithEmailPin(
        email: _emailController.text,
        pin: _pinController.text,
      );

      if (response.success) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Login failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: _pinController,
            decoration: InputDecoration(labelText: 'PIN'),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            child: _isLoading 
              ? CircularProgressIndicator() 
              : Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

### **Step 4: Using Service Providers**

#### **Home Screen with Services:**

```dart
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch authentication state
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final currentUser = ref.watch(currentUserProvider);
    
    // Watch featured services
    final featuredServicesAsync = ref.watch(featuredServicesProvider(null));

    if (!isAuthenticated) {
      return LoginScreen(); // Redirect to login
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${currentUser?.displayName ?? 'User'}'),
        actions: [
          IconButton(
            icon: Icon(Prbal.logout),
            onPressed: () async {
              final logout = ref.read(logoutProvider);
              await logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: featuredServicesAsync.when(
        data: (services) => ListView.builder(
          itemCount: services.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(services[index].title),
            subtitle: Text('₹${services[index].price}'),
            onTap: () {
              // Navigate to service details
            },
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
```

#### **Profile Screen:**

```dart
class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isProvider = ref.watch(isProviderProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        children: [
          Text('Name: ${user?.displayName ?? 'Unknown'}'),
          Text('Email: ${user?.email ?? 'Unknown'}'),
          Text('Type: ${user?.userType ?? 'Unknown'}'),
          Text('Balance: ₹${user?.balance ?? '0.00'}'),
          Text('Rating: ${user?.rating ?? 0.0} ⭐'),
          
          if (isProvider)
            ElevatedButton(
              onPressed: () {
                // Navigate to provider dashboard
              },
              child: Text('Provider Dashboard'),
            ),
            
          ElevatedButton(
            onPressed: () async {
              final logout = ref.read(logoutProvider);
              await logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
```

### **Step 5: Booking Management**

```dart
class BookingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProvider = ref.watch(isProviderProvider);
    
    // Use different providers based on user type
    final bookingsAsync = isProvider
        ? ref.watch(providerBookingsProvider(null))
        : ref.watch(userBookingsProvider(null));

    return Scaffold(
      appBar: AppBar(
        title: Text(isProvider ? 'Provider Bookings' : 'My Bookings'),
      ),
      body: bookingsAsync.when(
        data: (bookings) => ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) => Card(
            child: ListTile(
              title: Text('Booking #${bookings[index].id.substring(0, 8)}'),
              subtitle: Text('Status: ${bookings[index].status}'),
              trailing: Text('₹${bookings[index].totalAmount}'),
            ),
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
```

## 🎯 **Key Features Available**

### **Authentication**

- ✅ User registration (customer/provider/admin)
- ✅ PIN-based login
- ✅ Automatic token refresh
- ✅ Profile management
- ✅ Secure logout

### **Services**

- ✅ Browse all services
- ✅ Featured services
- ✅ Search and filter
- ✅ Service categories
- ✅ Provider service management

### **Bookings**

- ✅ Create bookings
- ✅ View user bookings
- ✅ Provider booking management
- ✅ Status updates
- ✅ Rescheduling/cancellation

### **State Management**

- ✅ Riverpod providers for all states
- ✅ Automatic cache invalidation
- ✅ Error handling
- ✅ Loading states

## 🚨 **Important Notes**

1. **API URL**: Update `ApiConfig.baseUrl` in `api_service.dart`
2. **Error Handling**: All API calls return `ApiResponse` with success/error states
3. **Authentication**: Users are automatically logged in after registration
4. **Tokens**: Access and refresh tokens are automatically managed
5. **Local Storage**: All user data persists across app restarts

## 🔄 **Next Steps**

1. Update your existing screens to use the new providers
2. Replace your current authentication logic
3. Test registration and login flows
4. Implement service browsing and booking features
5. Add proper error handling and loading states

## 📝 **Error Handling durgas**

```dart
try {
  final response = await authService.loginWithEmailPin(email: email, pin: pin);
  
  if (response.success) {
    // Handle success
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    // Handle API error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.message ?? 'Login failed')),
    );
  }
} catch (e) {
  // Handle network/unexpected errors
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Network error: $e')),
  );
}
```

## 🧪 **Testing**

Before going live, test with your local backend:

1. Set `baseUrl` to `http://localhost:8000`
2. Ensure your backend is running
3. Test registration, login, and API calls
4. Verify token refresh works
5. Test logout and session persistence

Your backend integration is now complete! 🎉
