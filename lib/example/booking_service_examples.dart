// This file demonstrates how to use the Booking Service APIs in your Flutter app
// Remove this file once you've integrated the services into your actual screens

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbal/services/booking_service.dart';

/// Comprehensive Booking Management Screen
class DurgasBookingManagementScreen extends ConsumerStatefulWidget {
  const DurgasBookingManagementScreen({super.key});

  @override
  ConsumerState<DurgasBookingManagementScreen> createState() =>
      _DurgasBookingManagementScreenState();
}

class _DurgasBookingManagementScreenState
    extends ConsumerState<DurgasBookingManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  BookingStatus? _selectedStatus;
  UserRole? _selectedRole;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: 'All Bookings'),
            Tab(icon: Icon(Icons.business), text: 'Provider'),
            Tab(icon: Icon(Icons.person), text: 'Customer'),
            Tab(icon: Icon(Icons.admin_panel_settings), text: 'Admin'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllBookingsTab(),
          _buildProviderBookingsTab(),
          _buildCustomerBookingsTab(),
          _buildAdminBookingsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateBookingDialog,
        tooltip: 'Create New Booking',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAllBookingsTab() {
    final filters = <String, dynamic>{
      if (_selectedStatus != null) 'status': _selectedStatus!.value,
      if (_selectedRole != null) 'role': _selectedRole!.value,
      if (_searchQuery != null) 'search': _searchQuery,
      'ordering': '-created_at',
    };

    final bookingsAsync =
        ref.watch(bookingListProvider(filters.isEmpty ? null : filters));

    return bookingsAsync.when(
      data: (bookingResponse) => _buildBookingsList(bookingResponse.results),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorWidget(error, () {
        // ignore: unused_result
        ref.refresh(bookingListProvider(filters.isEmpty ? null : filters));
      }),
    );
  }

  Widget _buildProviderBookingsTab() {
    final filters = <String, dynamic>{
      if (_selectedStatus != null) 'status': _selectedStatus!.value,
      'ordering': '-created_at',
    };

    final bookingsAsync =
        ref.watch(providerBookingsProvider(filters.isEmpty ? null : filters));

    return bookingsAsync.when(
      data: (bookingResponse) => _buildBookingsList(bookingResponse.results),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorWidget(error, () {
        // ignore: unused_result
        ref.refresh(providerBookingsProvider(filters.isEmpty ? null : filters));
      }),
    );
  }

  Widget _buildCustomerBookingsTab() {
    final filters = <String, dynamic>{
      if (_selectedStatus != null) 'status': _selectedStatus!.value,
      'ordering': '-created_at',
    };

    final bookingsAsync =
        ref.watch(customerBookingsProvider(filters.isEmpty ? null : filters));

    return bookingsAsync.when(
      data: (bookingResponse) => _buildBookingsList(bookingResponse.results),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorWidget(error, () {
        // ignore: unused_result
        ref.refresh(customerBookingsProvider(filters.isEmpty ? null : filters));
      }),
    );
  }

  Widget _buildAdminBookingsTab() {
    return FutureBuilder<List<Booking>>(
      future: _loadAdminBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error, () {
            setState(() {});
          });
        }
        return _buildBookingsList(snapshot.data ?? []);
      },
    );
  }

  Widget _buildBookingsList(List<Booking> bookings) {
    if (bookings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No bookings found', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) => _buildBookingCard(bookings[index]),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final statusColor = Color(int.parse(
        BookingService.getStatusColor(booking.status)
            .replaceFirst('#', '0xFF')));

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking #${booking.id.substring(0, 8)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Service: ${booking.service}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    BookingService.getStatusDisplayText(booking.status),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  '${booking.bookingDate.toLocal().toString().split(' ')[0]} | ${booking.startTime} - ${booking.endTime}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(child: Text(booking.address)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.currency_rupee, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  '₹${booking.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            if (booking.requirements.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Requirements: ${booking.requirements}',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _viewBookingDetails(booking.id),
                  child: const Text('View Details'),
                ),
                const SizedBox(width: 8),
                _buildActionButton(booking),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(Booking booking) {
    switch (booking.status) {
      case BookingStatus.pending:
        return ElevatedButton(
          onPressed: () => _showStatusUpdateDialog(booking),
          child: const Text('Update Status'),
        );
      case BookingStatus.confirmed:
        return ElevatedButton(
          onPressed: () => _showRescheduleDialog(booking),
          child: const Text('Reschedule'),
        );
      case BookingStatus.inProgress:
        return ElevatedButton(
          onPressed: () => _completeBooking(booking.id),
          child: const Text('Complete'),
        );
      case BookingStatus.disputed:
        return ElevatedButton(
          onPressed: () => _showDisputeResolutionDialog(booking),
          child: const Text('Resolve'),
        );
      default:
        return ElevatedButton(
          onPressed: () => _showBookingMenu(booking),
          child: const Text('Actions'),
        );
    }
  }

  Widget _buildErrorWidget(Object? error, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<List<Booking>> _loadAdminBookings() async {
    final bookingService = ref.read(bookingServiceProvider);
    final response = await bookingService.adminListAllBookings(
      status: _selectedStatus,
      ordering: '-created_at',
    );

    if (response.success && response.data != null) {
      return response.data!.results;
    } else {
      throw Exception(response.message ?? 'Failed to load admin bookings');
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Bookings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<BookingStatus>(
              value: _selectedStatus,
              decoration: const InputDecoration(labelText: 'Status'),
              items: BookingStatus.values
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child:
                            Text(BookingService.getStatusDisplayText(status)),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedStatus = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<UserRole>(
              value: _selectedRole,
              decoration: const InputDecoration(labelText: 'Role'),
              items: UserRole.values
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role.value.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedRole = value),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedStatus = null;
                _selectedRole = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    final searchController = TextEditingController(text: _searchQuery);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Bookings'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search in requirements and notes',
            hintText: 'Enter search term...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _searchQuery = null);
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _searchQuery =
                  searchController.text.isEmpty ? null : searchController.text);
              Navigator.pop(context);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showCreateBookingDialog() {
    final serviceController = TextEditingController();
    final addressController = TextEditingController();
    final requirementsController = TextEditingController();
    final amountController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    String startTime = '09:00';
    String endTime = '10:00';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create New Booking'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: serviceController,
                  decoration: const InputDecoration(labelText: 'Service ID'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: requirementsController,
                  decoration: const InputDecoration(labelText: 'Requirements'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Amount (₹)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                      'Date: ${selectedDate.toLocal().toString().split(' ')[0]}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setDialogState(() => selectedDate = date);
                    }
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text('Start: $startTime'),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: int.parse(startTime.split(':')[0]),
                              minute: int.parse(startTime.split(':')[1]),
                            ),
                          );
                          if (time != null) {
                            setDialogState(() => startTime =
                                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text('End: $endTime'),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: int.parse(endTime.split(':')[0]),
                              minute: int.parse(endTime.split(':')[1]),
                            ),
                          );
                          if (time != null) {
                            setDialogState(() => endTime =
                                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _createBooking(
                  serviceController.text,
                  addressController.text,
                  requirementsController.text,
                  double.tryParse(amountController.text) ?? 0,
                  selectedDate,
                  startTime,
                  endTime,
                );
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusUpdateDialog(Booking booking) {
    String selectedStatus = booking.status.value;
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Update Booking Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'New Status'),
                items: BookingStatus.values
                    .map((status) => DropdownMenuItem(
                          value: status.value,
                          child:
                              Text(BookingService.getStatusDisplayText(status)),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setDialogState(() => selectedStatus = value!),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateBookingStatus(
                  booking.id,
                  selectedStatus,
                  notesController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRescheduleDialog(Booking booking) {
    DateTime selectedDate = booking.bookingDate;
    String startTime = booking.startTime;
    String endTime = booking.endTime;
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Reschedule Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                    'Date: ${selectedDate.toLocal().toString().split(' ')[0]}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setDialogState(() => selectedDate = date);
                  }
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Start: $startTime'),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: int.parse(startTime.split(':')[0]),
                            minute: int.parse(startTime.split(':')[1]),
                          ),
                        );
                        if (time != null) {
                          setDialogState(() => startTime =
                              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('End: $endTime'),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: int.parse(endTime.split(':')[0]),
                            minute: int.parse(endTime.split(':')[1]),
                          ),
                        );
                        if (time != null) {
                          setDialogState(() => endTime =
                              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
                        }
                      },
                    ),
                  ),
                ],
              ),
              TextField(
                controller: reasonController,
                decoration:
                    const InputDecoration(labelText: 'Reason for rescheduling'),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _rescheduleBooking(
                  booking.id,
                  selectedDate,
                  startTime,
                  endTime,
                  reasonController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Reschedule'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDisputeResolutionDialog(Booking booking) {
    // Admin-only functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resolve Dispute'),
        content: const Text('Admin access required to resolve disputes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showBookingMenu(Booking booking) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Sync to Calendar'),
            onTap: () {
              Navigator.pop(context);
              _syncToCalendar(booking.id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.cancel),
            title: const Text('Cancel Booking'),
            onTap: () {
              Navigator.pop(context);
              _showCancelBookingDialog(booking);
            },
          ),
          ListTile(
            leading: const Icon(Icons.warning),
            title: const Text('Mark as Disputed'),
            onTap: () {
              Navigator.pop(context);
              _showMarkDisputedDialog(booking);
            },
          ),
        ],
      ),
    );
  }

  void _showCancelBookingDialog(Booking booking) {
    String selectedReason = CancellationReason.customerRequest.value;
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Cancel Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedReason,
                decoration:
                    const InputDecoration(labelText: 'Cancellation Reason'),
                items: CancellationReason.values
                    .map((reason) => DropdownMenuItem(
                          value: reason.value,
                          child: Text(
                              reason.value.replaceAll('_', ' ').toUpperCase()),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setDialogState(() => selectedReason = value!),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration:
                    const InputDecoration(labelText: 'Additional Notes'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep Booking'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _cancelBooking(
                    booking.id, selectedReason, notesController.text);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Cancel Booking'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMarkDisputedDialog(Booking booking) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Disputed'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Dispute Reason',
            hintText: 'Describe the issue...',
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _markAsDisputed(booking.id, reasonController.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Mark Disputed'),
          ),
        ],
      ),
    );
  }

  // API Call Methods

  Future<void> _createBooking(
    String serviceId,
    String address,
    String requirements,
    double amount,
    DateTime bookingDate,
    String startTime,
    String endTime,
  ) async {
    try {
      final bookingService = ref.read(bookingServiceProvider);

      final request = CreateBookingRequest(
        service: serviceId,
        bookingDate: bookingDate.toIso8601String().split('T')[0],
        startTime: startTime,
        endTime: endTime,
        amount: amount,
        address: address,
        requirements: requirements,
      );

      final response = await bookingService.createBooking(request);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking created successfully!')),
        );
        setState(() {}); // Refresh the lists
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message ?? 'Failed to create booking')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _updateBookingStatus(
      String bookingId, String status, String notes) async {
    try {
      final bookingService = ref.read(bookingServiceProvider);

      final request = StatusUpdateRequest(status: status, notes: notes);
      final response =
          await bookingService.updateBookingStatus(bookingId, request);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking status updated successfully!')),
        );
        setState(() {}); // Refresh the lists
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message ?? 'Failed to update status')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _rescheduleBooking(
    String bookingId,
    DateTime bookingDate,
    String startTime,
    String endTime,
    String reason,
  ) async {
    try {
      final bookingService = ref.read(bookingServiceProvider);

      final request = RescheduleBookingRequest(
        bookingDate: bookingDate.toIso8601String().split('T')[0],
        startTime: startTime,
        endTime: endTime,
        rescheduledReason: reason,
      );

      final response =
          await bookingService.rescheduleBooking(bookingId, request);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking rescheduled successfully!')),
        );
        setState(() {}); // Refresh the lists
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response.message ?? 'Failed to reschedule booking')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _cancelBooking(
      String bookingId, String reason, String notes) async {
    try {
      final bookingService = ref.read(bookingServiceProvider);

      final request = CancelBookingRequest(
        cancellationReason: reason,
        notes: notes.isEmpty ? null : notes,
      );

      final response = await bookingService.cancelBooking(bookingId, request);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking cancelled successfully!')),
        );
        setState(() {}); // Refresh the lists
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message ?? 'Failed to cancel booking')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _markAsDisputed(String bookingId, String reason) async {
    try {
      final bookingService = ref.read(bookingServiceProvider);
      final response =
          await bookingService.customerMarkDisputed(bookingId, reason);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking marked as disputed!')),
        );
        setState(() {}); // Refresh the lists
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message ?? 'Failed to mark as disputed')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _completeBooking(String bookingId) async {
    try {
      final bookingService = ref.read(bookingServiceProvider);
      final response = await bookingService.providerCompleteService(bookingId);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking marked as completed!')),
        );
        setState(() {}); // Refresh the lists
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message ?? 'Failed to complete booking')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _syncToCalendar(String bookingId) async {
    // Show calendar provider selection
    final provider = await showDialog<CalendarProvider>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync to Calendar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: CalendarProvider.values
              .map((provider) => ListTile(
                    title: Text(provider.value.toUpperCase()),
                    onTap: () => Navigator.pop(context, provider),
                  ))
              .toList(),
        ),
      ),
    );

    if (provider != null) {
      try {
        final bookingService = ref.read(bookingServiceProvider);

        final request = CalendarSyncRequest(
          bookingId: bookingId,
          provider: provider.value,
          authToken: 'dummy_token', // Replace with actual auth token
          calendarId: 'primary',
          createReminder: true,
          reminderMinutes: 30,
        );

        final response = await bookingService.syncBookingToCalendar(request);

        if (!mounted) return;

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking synced to calendar!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(response.message ?? 'Failed to sync to calendar')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _viewBookingDetails(String bookingId) async {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final bookingAsync = ref.watch(bookingProvider(bookingId));

          return bookingAsync.when(
            data: (booking) => AlertDialog(
              title: Text('Booking #${booking.id.substring(0, 8)}'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDetailRow('Service', booking.service),
                    _buildDetailRow('Status',
                        BookingService.getStatusDisplayText(booking.status)),
                    _buildDetailRow('Date',
                        booking.bookingDate.toLocal().toString().split(' ')[0]),
                    _buildDetailRow(
                        'Time', '${booking.startTime} - ${booking.endTime}'),
                    _buildDetailRow(
                        'Amount', '₹${booking.amount.toStringAsFixed(2)}'),
                    _buildDetailRow('Address', booking.address),
                    if (booking.customer != null)
                      _buildDetailRow('Customer', booking.customer!),
                    if (booking.provider != null)
                      _buildDetailRow('Provider', booking.provider!),
                    _buildDetailRow('Requirements', booking.requirements),
                    if (booking.notes != null)
                      _buildDetailRow('Notes', booking.notes!),
                    if (booking.rescheduledReason != null)
                      _buildDetailRow(
                          'Reschedule Reason', booking.rescheduledReason!),
                    if (booking.cancellationReason != null)
                      _buildDetailRow(
                          'Cancellation Reason', booking.cancellationReason!),
                    _buildDetailRow(
                        'Created', booking.createdAt.toLocal().toString()),
                    _buildDetailRow(
                        'Updated', booking.updatedAt.toLocal().toString()),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
            loading: () => const AlertDialog(
              content: SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (error, stack) => AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to load booking details: $error'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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

/// Usage Instructions:
///
/// To integrate this booking management into your app:
///
/// 1. Add to your router:
///    ```dart
///    '/booking-management': (context) => const DurgasBookingManagementScreen(),
///    ```
///
/// 2. Use individual booking methods:
///    ```dart
///    final bookingService = ref.read(bookingServiceProvider);
///    final response = await bookingService.createBooking(request);
///    ```
///
/// 3. Watch booking providers:
///    ```dart
///    final bookings = ref.watch(bookingListProvider(filters));
///    ```
///
/// 4. Available API methods from Postman collection:
///    - listBookings() - List with filters
///    - createBooking() - Create new booking
///    - getBooking() - Get single booking
///    - updateBookingStatus() - Update status
///    - rescheduleBooking() - Reschedule
///    - cancelBooking() - Cancel booking
///    - syncBookingToCalendar() - Calendar sync
///    - customerConfirmBooking() - Customer actions
///    - providerStartService() - Provider actions
///    - providerCompleteService() - Provider actions
///    - customerMarkDisputed() - Dispute handling
///    - providerMarkDisputed() - Dispute handling
///    - adminListAllBookings() - Admin operations
///    - adminListDisputedBookings() - Admin operations
///    - adminForceStatusUpdate() - Admin operations
///    - adminViewBookingDetails() - Admin operations
