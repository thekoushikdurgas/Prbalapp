import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../services/sync_service.dart';
import '../services/hive_service.dart';
import '../services/api_service.dart';

/// Example widget demonstrating sync service usage
class SyncServiceExample extends ConsumerStatefulWidget {
  const SyncServiceExample({super.key});

  @override
  ConsumerState<SyncServiceExample> createState() => _SyncServiceExampleState();
}

class _SyncServiceExampleState extends ConsumerState<SyncServiceExample> {
  bool _isLoading = false;
  String _statusMessage = '';
  SyncUserProfile? _cachedProfile;

  @override
  void initState() {
    super.initState();
    _loadCachedData();
  }

  /// Load cached data on widget initialization
  Future<void> _loadCachedData() async {
    try {
      final syncService = ref.read(syncServiceProvider.notifier);
      await syncService.initialize();

      // Load cached profile
      _cachedProfile = await syncService.getCachedUserProfile();

      setState(() {
        _statusMessage = _cachedProfile != null
            ? 'Cached profile loaded for ${_cachedProfile!.username}'
            : 'No cached profile found';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error loading cached data: $e';
      });
    }
  }

  /// Download user profile for offline use
  Future<void> _downloadProfile() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Downloading user profile...';
    });

    try {
      final syncService = ref.read(syncServiceProvider.notifier);
      final response = await syncService.downloadUserProfile();

      if (response.success && response.data != null) {
        setState(() {
          _cachedProfile = response.data;
          _statusMessage = 'Profile downloaded and cached successfully!';
        });
      } else {
        setState(() {
          _statusMessage = 'Failed to download profile: ${response.message}';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error downloading profile: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Download services with different strategies
  Future<void> _downloadServices(String strategy) async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Downloading services ($strategy)...';
    });

    try {
      final syncService = ref.read(syncServiceProvider.notifier);
      late ApiResponse<SyncServicesResponse> response;

      switch (strategy) {
        case 'all':
          response = await syncService.downloadServices();
          break;
        case 'limited':
          response = await syncService.downloadLimitedServices(limit: 20);
          break;
        case 'category':
          response = await syncService.downloadServicesByCategory('cleaning');
          break;
        case 'location':
          response = await syncService.downloadServicesByLocation('Mumbai');
          break;
        case 'quick':
          response = await syncService.performQuickSync();
          break;
        default:
          response = await syncService.downloadLimitedServices();
      }

      if (response.success && response.data != null) {
        final serviceCount = response.data!.services.length;
        setState(() {
          _statusMessage =
              'Downloaded $serviceCount services ($strategy strategy)';
        });
      } else {
        setState(() {
          _statusMessage = 'Failed to download services: ${response.message}';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error downloading services: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Create and store offline operations
  Future<void> _createOfflineOperations() async {
    try {
      // Create offline bid
      final offlineBid = OfflineBid(
        clientTempId: 'bid_${DateTime.now().millisecondsSinceEpoch}',
        service: 'service_123',
        amount: 500.0,
        message: 'Created while offline',
        duration: '2 hours',
        currency: 'INR',
        scheduledDateTime: DateTime.now().add(Duration(days: 1)),
      );

      await HiveService.saveOfflineBid(
          offlineBid.clientTempId, offlineBid.toJson());

      // Create offline booking
      final offlineBooking = OfflineBooking(
        clientTempId: 'booking_${DateTime.now().millisecondsSinceEpoch}',
        service: 'service_456',
        provider: 'provider_789',
        bookingDate: DateTime.now().add(Duration(days: 2)),
        startTime: '10:00',
        endTime: '12:00',
        amount: 800.0,
        address: '123 Main Street, Mumbai',
        requirements: 'Please bring cleaning supplies',
      );

      await HiveService.saveOfflineBooking(
          offlineBooking.clientTempId, offlineBooking.toJson());

      // Create offline message
      final offlineMessage = OfflineMessage(
        clientTempId: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        thread: 'thread_123',
        content: 'This message was sent while offline',
        messageType: 'text',
      );

      await HiveService.saveOfflineMessage(
          offlineMessage.clientTempId, offlineMessage.toJson());

      setState(() {
        _statusMessage =
            'Created offline operations: 1 bid, 1 booking, 1 message';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error creating offline operations: $e';
      });
    }
  }

  /// Upload all pending offline data
  Future<void> _uploadOfflineData() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Uploading offline data...';
    });

    try {
      final syncService = ref.read(syncServiceProvider.notifier);

      // Get all offline data
      final offlineBids = HiveService.getOfflineBids();
      final offlineBookings = HiveService.getOfflineBookings();
      final offlineMessages = HiveService.getOfflineMessages();

      if (offlineBids.isEmpty &&
          offlineBookings.isEmpty &&
          offlineMessages.isEmpty) {
        setState(() {
          _statusMessage = 'No offline data to upload';
        });
        return;
      }

      // Create upload request
      final request = UploadChangesRequest(
        timestamp: DateTime.now(),
        bids: offlineBids.entries
            .map((e) => OfflineBid.fromJson(e.value))
            .toList(),
        bookings: offlineBookings.entries
            .map((e) => OfflineBooking.fromJson(e.value))
            .toList(),
        messages: offlineMessages.entries
            .map((e) => OfflineMessage.fromJson(e.value))
            .toList(),
      );

      final response = await syncService.uploadOfflineChanges(request);

      if (response.success && response.data != null) {
        final result = response.data!;
        setState(() {
          _statusMessage = 'Upload successful!\n'
              'Processed: ${result.processedBids.length} bids, '
              '${result.processedBookings.length} bookings, '
              '${result.processedMessages.length} messages\n'
              'Errors: ${result.errors.length}';
        });
      } else {
        setState(() {
          _statusMessage = 'Upload failed: ${response.message}';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error uploading data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Clear all cached data
  Future<void> _clearAllData() async {
    try {
      final syncService = ref.read(syncServiceProvider.notifier);
      await syncService.clearAllSyncData();
      await HiveService.clearOfflineData();

      setState(() {
        _cachedProfile = null;
        _statusMessage = 'All cached data cleared';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error clearing data: $e';
      });
    }
  }

  /// Perform a full sync of both profile and services
  Future<void> _performFullSync() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Performing full sync...';
    });

    try {
      final syncService = ref.read(syncServiceProvider.notifier);
      await syncService.downloadUserProfile();
      await syncService.downloadServices();

      setState(() {
        _statusMessage = 'Full sync completed successfully!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error performing full sync: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Perform a conditional sync based on certain conditions
  Future<void> _performConditionalSync() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Performing conditional sync...';
    });

    try {
      final syncService = ref.read(syncServiceProvider.notifier);
      await syncService.downloadUserProfile();
      await syncService.downloadServicesByCategory('cleaning');

      setState(() {
        _statusMessage = 'Conditional sync completed successfully!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error performing conditional sync: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Download services with advanced filters
  Future<void> _downloadServicesWithFilters() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Downloading services with advanced filters...';
    });

    try {
      final syncService = ref.read(syncServiceProvider.notifier);
      final response = await syncService.downloadServicesWithAdvancedFilters();

      if (response.success && response.data != null) {
        final serviceCount = response.data!.services.length;
        setState(() {
          _statusMessage =
              'Downloaded $serviceCount services with advanced filters';
        });
      } else {
        setState(() {
          _statusMessage =
              'Failed to download services with advanced filters: ${response.message}';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error downloading services with advanced filters: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final syncedServices = ref.watch(syncServiceProvider);
    final offlineCounts = HiveService.getOfflineDataCounts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sync Service Example'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sync Status',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),

                    // Synced services status
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: syncedServices != null
                            ? Colors.green
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        syncedServices != null
                            ? 'Services Synced: ${syncedServices.length}'
                            : 'Services Not Synced',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    SizedBox(height: 8),

                    // Cached profile status
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            _cachedProfile != null ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _cachedProfile != null
                            ? 'Profile Cached: ${_cachedProfile!.username}'
                            : 'No Cached Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    SizedBox(height: 8),

                    // Offline data status
                    if (offlineCounts.values.any((count) => count > 0))
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Pending: ${offlineCounts['bids']} bids, '
                          '${offlineCounts['bookings']} bookings, '
                          '${offlineCounts['messages']} messages',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Status Message
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _statusMessage.isEmpty ? 'Ready to sync' : _statusMessage,
                style: TextStyle(fontSize: 14),
              ),
            ),

            SizedBox(height: 16),

            // Action Buttons
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Actions
                    Text(
                      'Profile Actions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _downloadProfile,
                      child: Text('Download Profile'),
                    ),

                    SizedBox(height: 16),

                    // Service Actions
                    Text(
                      'Service Sync Actions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () => _downloadServices('quick'),
                            child: Text('Quick Sync'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () => _downloadServices('all'),
                            child: Text('Full Sync'),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () => _downloadServices('category'),
                            child: Text('By Category'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () => _downloadServices('location'),
                            child: Text('By Location'),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    // New advanced sync options
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                _isLoading ? null : () => _performFullSync(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                            ),
                            child: Text('Full Sync (Profile + Services)'),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () => _performConditionalSync(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                            ),
                            child: Text('Conditional Sync'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () => _downloadServicesWithFilters(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                            ),
                            child: Text('Advanced Filters'),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Offline Actions
                    Text(
                      'Offline Actions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _createOfflineOperations,
                      child: Text('Create Offline Data'),
                    ),

                    SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _uploadOfflineData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Upload Offline Data'),
                    ),

                    SizedBox(height: 16),

                    // Cleanup Actions
                    Text(
                      'Cleanup Actions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _clearAllData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('Clear All Data'),
                    ),
                  ],
                ),
              ),
            ),

            // Loading Indicator
            if (_isLoading)
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Helper methods for demonstrating sync service integration
class SyncServiceHelper {
  /// Initialize sync service on app startup
  static Future<void> initializeOnAppStartup(WidgetRef ref) async {
    try {
      if (kDebugMode) {
        debugPrint('SyncServiceHelper: Initializing sync service...');
      }

      final syncService = ref.read(syncServiceProvider.notifier);

      // Initialize the service
      await syncService.initialize();

      // Check for pending offline data and upload if connected
      if (HiveService.hasPendingOfflineData()) {
        if (kDebugMode) {
          debugPrint(
              'SyncServiceHelper: Found pending offline data, attempting upload...');
        }
        await _uploadPendingDataSafely(syncService);
      }

      // Perform initial sync if no cached data
      final cachedServices = HiveService.getSyncedServices();
      if (cachedServices == null) {
        if (kDebugMode) {
          debugPrint(
              'SyncServiceHelper: No cached services found, performing initial sync...');
        }
        await syncService.downloadLimitedServices(limit: 30);
      }

      if (kDebugMode) {
        debugPrint('SyncServiceHelper: Sync service initialization completed');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncServiceHelper: Error during initialization - $e');
      }
    }
  }

  /// Safely upload pending data (handles network errors gracefully)
  static Future<void> _uploadPendingDataSafely(
      SyncServiceProvider syncService) async {
    try {
      final offlineBids = HiveService.getOfflineBids();
      final offlineBookings = HiveService.getOfflineBookings();
      final offlineMessages = HiveService.getOfflineMessages();

      if (offlineBids.isNotEmpty ||
          offlineBookings.isNotEmpty ||
          offlineMessages.isNotEmpty) {
        final request = UploadChangesRequest(
          timestamp: DateTime.now(),
          bids: offlineBids.entries
              .map((e) => OfflineBid.fromJson(e.value))
              .toList(),
          bookings: offlineBookings.entries
              .map((e) => OfflineBooking.fromJson(e.value))
              .toList(),
          messages: offlineMessages.entries
              .map((e) => OfflineMessage.fromJson(e.value))
              .toList(),
        );

        final response = await syncService.uploadOfflineChanges(request);
        if (response.success) {
          if (kDebugMode) {
            debugPrint(
                'SyncServiceHelper: Successfully uploaded pending offline data');
          }
        } else {
          if (kDebugMode) {
            debugPrint(
                'SyncServiceHelper: Failed to upload offline data - ${response.message}');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncServiceHelper: Error uploading pending data - $e');
      }
      // Don't throw error - this is a background operation
    }
  }

  /// Handle connectivity changes
  static Future<void> onConnectivityChanged(
      WidgetRef ref, bool isConnected) async {
    if (isConnected) {
      try {
        if (kDebugMode) {
          debugPrint(
              'SyncServiceHelper: Connectivity restored, performing sync...');
        }

        final syncService = ref.read(syncServiceProvider.notifier);

        // Upload any pending offline data
        await _uploadPendingDataSafely(syncService);

        // Refresh cached data if it's old (older than 1 hour)
        final cachedServices = HiveService.getSyncedServices();
        if (cachedServices != null) {
          final metadata = SyncMetadata.fromJson(cachedServices);
          final hoursSinceSync =
              DateTime.now().difference(metadata.syncTimestamp).inHours;

          if (hoursSinceSync > 1) {
            if (kDebugMode) {
              debugPrint(
                  'SyncServiceHelper: Cached data is $hoursSinceSync hours old, refreshing...');
            }
            await syncService.downloadLimitedServices();
          }
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('SyncServiceHelper: Error during connectivity sync - $e');
        }
      }
    }
  }

  /// Get sync service status information
  static Map<String, dynamic> getSyncStatus() {
    final offlineCounts = HiveService.getOfflineDataCounts();
    final hasPendingData = HiveService.hasPendingOfflineData();

    return {
      'offline_data_counts': offlineCounts,
      'has_pending_data': hasPendingData,
      'storage_healthy': HiveService.isStorageHealthy(),
      'total_pending_items':
          offlineCounts.values.fold(0, (sum, count) => sum + count),
    };
  }
}
