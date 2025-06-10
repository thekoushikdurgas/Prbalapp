// This file demonstrates how to use the backend-integrated services in your Flutter app
// Remove this file once you've integrated the services into your actual screens

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbal/services/auth_service.dart';
import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/services/api_service.dart';
import '../services/app_services.dart' hide isAuthenticatedProvider;

/// durgas: Registration Screen
class DurgasRegistrationScreen extends ConsumerStatefulWidget {
  const DurgasRegistrationScreen({super.key});

  @override
  ConsumerState<DurgasRegistrationScreen> createState() =>
      _DurgasRegistrationScreenState();
}

class _DurgasRegistrationScreenState
    extends ConsumerState<DurgasRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _isLoading = false;
  String _selectedUserType = 'customer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedUserType,
                decoration: const InputDecoration(labelText: 'User Type'),
                items: const [
                  DropdownMenuItem(value: 'customer', child: Text('Customer')),
                  DropdownMenuItem(
                      value: 'provider', child: Text('Service Provider')),
                ],
                onChanged: (value) =>
                    setState(() => _selectedUserType = value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegistration,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authProvider.notifier);

      late final ApiResponse<RegistrationResponse> response;

      if (_selectedUserType == 'customer') {
        response = await authService.registerCustomer(
          username: _usernameController.text,
          email: _emailController.text,
          phoneNumber:
              _phoneController.text.isNotEmpty ? _phoneController.text : null,
          firstName: _firstNameController.text.isNotEmpty
              ? _firstNameController.text
              : null,
          lastName: _lastNameController.text.isNotEmpty
              ? _lastNameController.text
              : null,
        );
      } else {
        response = await authService.registerProvider(
          username: _usernameController.text,
          email: _emailController.text,
          phoneNumber:
              _phoneController.text.isNotEmpty ? _phoneController.text : null,
          firstName: _firstNameController.text.isNotEmpty
              ? _firstNameController.text
              : null,
          lastName: _lastNameController.text.isNotEmpty
              ? _lastNameController.text
              : null,
        );
      }

      if (response.success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message ?? 'Registration successful!')),
        );
        // Navigate to home or PIN setup screen
        Navigator.pushReplacementNamed(context, '/pin-setup');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Registration failed')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}

/// durgas: Login Screen
class DurgasLoginScreen extends ConsumerStatefulWidget {
  const DurgasLoginScreen({super.key});

  @override
  ConsumerState<DurgasLoginScreen> createState() => _DurgasLoginScreenState();
}

class _DurgasLoginScreenState extends ConsumerState<DurgasLoginScreen> {
  final _emailController = TextEditingController();
  final _pinController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _pinController,
              decoration: const InputDecoration(labelText: 'PIN'),
              obscureText: true,
              maxLength: 6,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authProvider.notifier);

      final response = await authService.loginWithPhonePin(
        phoneNumber: _emailController
            .text, // Note: using email field for phone in this example
        pin: _pinController.text,
      );

      if (response.success) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Login failed')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pinController.dispose();
    super.dispose();
  }
}

/// durgas: Services List Screen
class DurgasServicesScreen extends ConsumerWidget {
  const DurgasServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch featured services
    final featuredServicesAsync = ref.watch(featuredServicesProvider(null));

    // Watch all services with no filters
    final servicesAsync = ref.watch(servicesProvider(null));

    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: CustomScrollView(
        slivers: [
          // Featured Services Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Featured Services',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          featuredServicesAsync.when(
            data: (services) => SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: services.length,
                  itemBuilder: (context, index) =>
                      _buildServiceCard(services[index]),
                ),
              ),
            ),
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverToBoxAdapter(
              child: Center(child: Text('Error: $error')),
            ),
          ),

          // All Services Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'All Services',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          servicesAsync.when(
            data: (services) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildServiceListTile(services[index]),
                childCount: services.length,
              ),
            ),
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverToBoxAdapter(
              child: Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: service.imageUrl != null
                    ? Image.network(service.imageUrl!, fit: BoxFit.cover)
                    : const Center(child: Icon(Icons.image)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('₹${service.price}'),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text('${service.rating} (${service.reviewCount})'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceListTile(Service service) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            service.imageUrl != null ? NetworkImage(service.imageUrl!) : null,
        child: service.imageUrl == null ? const Icon(Icons.image) : null,
      ),
      title: Text(service.title),
      subtitle: Text(service.description),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('₹${service.price}'),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              Text('${service.rating}'),
            ],
          ),
        ],
      ),
      onTap: () {
        // Navigate to service details
      },
    );
  }
}

/// durgas: User Profile Screen
class DurgasProfileScreen extends ConsumerWidget {
  const DurgasProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    if (!isAuthenticated || user == null) {
      return const Scaffold(
        body: Center(child: Text('Not authenticated')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final logout = ref.read(logoutProvider);
              await logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: user.profilePicture != null
                    ? NetworkImage(user.profilePicture!)
                    : null,
                child: user.profilePicture == null
                    ? Text(user.displayName.substring(0, 1).toUpperCase())
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow('Name', user.displayName),
            _buildInfoRow('Email', user.email),
            _buildInfoRow('Phone', user.phoneNumber ?? 'Not provided'),
            _buildInfoRow('User Type', user.userType.toUpperCase()),
            _buildInfoRow('Location', user.location ?? 'Not provided'),
            _buildInfoRow('Balance', '₹${user.balance}'),
            _buildInfoRow('Rating', '${user.rating} ⭐'),
            _buildInfoRow('Verified', user.isVerified ? 'Yes' : 'No'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to edit profile screen
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

/// durgas: Bookings Screen
class DurgasBookingsScreen extends ConsumerWidget {
  const DurgasBookingsScreen({super.key});

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
        data: (bookings) {
          if (bookings.isEmpty) {
            return const Center(child: Text('No bookings found'));
          }

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) => _buildBookingCard(bookings[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking #${booking.id.substring(0, 8)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(booking.status.toUpperCase()),
                  backgroundColor: _getStatusColor(booking.status),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Service ID: ${booking.serviceId}'),
            Text('Scheduled: ${booking.scheduledDate}'),
            Text('Amount: ₹${booking.totalAmount}'),
            if (booking.customerNotes.isNotEmpty)
              Text('Notes: ${booking.customerNotes}'),
            if (booking.providerNotes != null)
              Text('Provider Notes: ${booking.providerNotes}'),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green.shade100;
      case 'pending':
        return Colors.orange.shade100;
      case 'completed':
        return Colors.blue.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}

/// How to initialize the app services in your main.dart:
///
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // Initialize app services
///   await AppServices.initialize();
///
///   runApp(
///     ProviderScope(
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
