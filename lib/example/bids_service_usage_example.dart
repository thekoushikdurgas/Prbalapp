import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/bids_service.dart';

/// Example usage of the BidsService
/// This file demonstrates how to use all the bid-related operations
class BidsServiceUsageExample extends ConsumerWidget {
  const BidsServiceUsageExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bidsService = ref.read(bidsServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bids Service Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              'Basic Bid Operations',
              [
                ElevatedButton(
                  onPressed: () => _listAllBids(bidsService),
                  child: const Text('List All Bids'),
                ),
                ElevatedButton(
                  onPressed: () => _getBidDetails(bidsService),
                  child: const Text('Get Bid Details'),
                ),
                ElevatedButton(
                  onPressed: () => _createBid(bidsService),
                  child: const Text('Create Bid'),
                ),
                ElevatedButton(
                  onPressed: () => _updateBid(bidsService),
                  child: const Text('Update Bid'),
                ),
                ElevatedButton(
                  onPressed: () => _deleteBid(bidsService),
                  child: const Text('Delete Bid'),
                ),
              ],
            ),
            _buildSection(
              'Bid Actions',
              [
                ElevatedButton(
                  onPressed: () => _acceptBid(bidsService),
                  child: const Text('Accept Bid'),
                ),
                ElevatedButton(
                  onPressed: () => _rejectBid(bidsService),
                  child: const Text('Reject Bid'),
                ),
              ],
            ),
            _buildSection(
              'Filtering & Search',
              [
                ElevatedButton(
                  onPressed: () => _filterBidsByService(bidsService),
                  child: const Text('Filter by Service'),
                ),
                ElevatedButton(
                  onPressed: () => _filterBidsByProvider(bidsService),
                  child: const Text('Filter by Provider'),
                ),
                ElevatedButton(
                  onPressed: () => _filterBidsByStatus(bidsService),
                  child: const Text('Filter by Status'),
                ),
                ElevatedButton(
                  onPressed: () => _searchBids(bidsService),
                  child: const Text('Search Bids'),
                ),
              ],
            ),
            _buildSection(
              'Sorting',
              [
                ElevatedButton(
                  onPressed: () => _sortBidsByAmount(bidsService),
                  child: const Text('Sort by Amount'),
                ),
                ElevatedButton(
                  onPressed: () => _sortBidsByDate(bidsService),
                  child: const Text('Sort by Date'),
                ),
              ],
            ),
            _buildSection(
              'Status-Specific Queries',
              [
                ElevatedButton(
                  onPressed: () => _getPendingBids(bidsService),
                  child: const Text('Get Pending Bids'),
                ),
                ElevatedButton(
                  onPressed: () => _getAcceptedBids(bidsService),
                  child: const Text('Get Accepted Bids'),
                ),
                ElevatedButton(
                  onPressed: () => _getCompletedBids(bidsService),
                  child: const Text('Get Completed Bids'),
                ),
              ],
            ),
            _buildSection(
              'AI Features',
              [
                ElevatedButton(
                  onPressed: () => _getSmartPricing(bidsService),
                  child: const Text('Get AI Smart Pricing'),
                ),
                ElevatedButton(
                  onPressed: () => _createAISuggestedBid(bidsService),
                  child: const Text('Create AI-Suggested Bid'),
                ),
              ],
            ),
            _buildSection(
              'Using Riverpod Providers',
              [
                ElevatedButton(
                  onPressed: () => _showRiverpodExamples(context, ref),
                  child: const Text('Show Provider Examples'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children.map((child) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: child,
                )),
          ],
        ),
      ),
    );
  }

  // === BASIC OPERATIONS ===

  Future<void> _listAllBids(BidsService service) async {
    try {
      final response = await service.listBids();
      if (response.success) {
        debugPrint('✅ Found ${response.data?.length ?? 0} bids');
        response.data?.forEach((bid) {
          debugPrint(
              'Bid ${bid.id}: ${bid.amount} ${bid.currency} - ${bid.status}');
        });
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  Future<void> _getBidDetails(BidsService service) async {
    try {
      const bidId = 'your-bid-id-here'; // Replace with actual bid ID
      final response = await service.getBidDetails(bidId);
      if (response.success && response.data != null) {
        final bid = response.data!;
        debugPrint('✅ Bid Details:');
        debugPrint('ID: ${bid.id}');
        debugPrint('Amount: ${bid.amount} ${bid.currency}');
        debugPrint('Status: ${bid.status}');
        debugPrint('Message: ${bid.message}');
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  Future<void> _createBid(BidsService service) async {
    try {
      final request = CreateBidRequest(
        service: 'service-id-here', // Replace with actual service ID
        amount: 75.00,
        currency: 'INR',
        duration: '3 hours',
        scheduledDateTime: DateTime.now().add(const Duration(days: 1)),
        message: 'I can provide high-quality service with competitive pricing.',
        location: 'Bangalore, India',
        paymentDetails: {
          'payment_method': 'online',
          'advance_required': true,
          'advance_percentage': 20,
        },
      );

      final response = await service.createBid(request);
      if (response.success && response.data != null) {
        debugPrint('✅ Bid created successfully!');
        debugPrint('Bid ID: ${response.data!.id}');
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  Future<void> _updateBid(BidsService service) async {
    try {
      const bidId = 'your-bid-id-here'; // Replace with actual bid ID
      final request = UpdateBidRequest(
        amount: 80.00,
        message: 'Updated bid with revised pricing based on requirements.',
      );

      final response = await service.partialUpdateBid(bidId, request);
      if (response.success) {
        debugPrint('✅ Bid updated successfully!');
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  Future<void> _deleteBid(BidsService service) async {
    try {
      const bidId = 'your-bid-id-here'; // Replace with actual bid ID
      final response = await service.deleteBid(bidId);
      if (response.success) {
        debugPrint('✅ Bid deleted successfully!');
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  // === BID ACTIONS ===

  Future<void> _acceptBid(BidsService service) async {
    try {
      const bidId = 'your-bid-id-here'; // Replace with actual bid ID
      final request = AcceptBidRequest(
        bookingDate: DateTime.now().add(const Duration(days: 2)),
        specialInstructions: 'Please bring eco-friendly supplies.',
        paymentMethod: 'online',
      );

      final response = await service.acceptBid(bidId, request);
      if (response.success) {
        debugPrint('✅ Bid accepted successfully!');
        debugPrint('Booking created: ${response.data}');
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  Future<void> _rejectBid(BidsService service) async {
    try {
      const bidId = 'your-bid-id-here'; // Replace with actual bid ID
      final response = await service.rejectBid(bidId);
      if (response.success) {
        debugPrint('✅ Bid rejected successfully!');
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  // === FILTERING & SEARCH ===

  Future<void> _filterBidsByService(BidsService service) async {
    try {
      const serviceId = 'your-service-id-here';
      final response = await service.getBidsByService(serviceId);
      if (response.success) {
        debugPrint(
            '✅ Found ${response.data?.length ?? 0} bids for service $serviceId');
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  Future<void> _filterBidsByProvider(BidsService service) async {
    try {
      const providerId = 'your-provider-id-here';
      final response = await service.getBidsByProvider(providerId);
      if (response.success) {
        debugPrint(
            '✅ Found ${response.data?.length ?? 0} bids from provider $providerId');
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  Future<void> _filterBidsByStatus(BidsService service) async {
    try {
      final response = await service.getBidsByStatus('pending');
      if (response.success) {
        debugPrint('✅ Found ${response.data?.length ?? 0} pending bids');
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  Future<void> _searchBids(BidsService service) async {
    try {
      final response = await service.searchBids('cleaning');
      if (response.success) {
        debugPrint(
            '✅ Found ${response.data?.length ?? 0} bids matching "cleaning"');
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  // === SORTING ===

  Future<void> _sortBidsByAmount(BidsService service) async {
    try {
      final response = await service.getBidsSortedByAmount(descending: true);
      if (response.success) {
        debugPrint('✅ Bids sorted by amount (highest first):');
        response.data?.forEach((bid) {
          debugPrint(
              '${bid.amount} ${bid.currency} - ${bid.message.substring(0, 50)}...');
        });
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  Future<void> _sortBidsByDate(BidsService service) async {
    try {
      final response = await service.getBidsSortedByDate();
      if (response.success) {
        debugPrint('✅ Bids sorted by date (newest first):');
        response.data?.forEach((bid) {
          debugPrint('${bid.createdAt} - ${bid.amount} ${bid.currency}');
        });
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  // === STATUS-SPECIFIC QUERIES ===

  Future<void> _getPendingBids(BidsService service) async {
    try {
      final response = await service.getPendingBids();
      if (response.success) {
        debugPrint('✅ Found ${response.data?.length ?? 0} pending bids');
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  Future<void> _getAcceptedBids(BidsService service) async {
    try {
      final response = await service.getAcceptedBids();
      if (response.success) {
        debugPrint('✅ Found ${response.data?.length ?? 0} accepted bids');
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  Future<void> _getCompletedBids(BidsService service) async {
    try {
      final response = await service.getCompletedBids();
      if (response.success) {
        debugPrint('✅ Found ${response.data?.length ?? 0} completed bids');
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  // === AI FEATURES ===

  Future<void> _getSmartPricing(BidsService service) async {
    try {
      const serviceId = 'your-service-id-here';
      final response = await service.getSmartPricing(serviceId);
      if (response.success && response.data != null) {
        final pricing = response.data!;
        debugPrint('✅ Smart Pricing Analysis:');
        debugPrint('Optimal Price: ${pricing.optimalPrice}');
        debugPrint('Price Range: ${pricing.minPrice} - ${pricing.maxPrice}');
        debugPrint('Confidence: ${pricing.confidenceScore}');
        debugPrint('Analysis: ${pricing.marketAnalysis}');
        debugPrint('Recommendations: ${pricing.recommendations.join(', ')}');
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  Future<void> _createAISuggestedBid(BidsService service) async {
    try {
      final request = CreateBidRequest(
        service: 'service-id-here', // Replace with actual service ID
        amount: 65.00,
        currency: 'INR',
        duration: '2.5 hours',
        scheduledDateTime: DateTime.now().add(const Duration(days: 1)),
        message:
            'Professional service as suggested by AI analysis. Competitive pricing based on market research.',
        location: 'Bangalore, India',
        isAiSuggested: true,
        aiSuggestionId: 'suggestion-id-here',
        aiSuggestedAmount: 65.00,
        paymentDetails: {
          'payment_method': 'online',
          'advance_required': true,
        },
      );

      final response = await service.createBid(request);
      if (response.success && response.data != null) {
        debugPrint('✅ AI-suggested bid created successfully!');
        debugPrint('Bid ID: ${response.data!.id}');
        debugPrint('AI Suggested: ${response.data!.isAiSuggested}');
      } else {
        debugPrint('❌ Error: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
    }
  }

  // === RIVERPOD PROVIDER EXAMPLES ===

  void _showRiverpodExamples(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Riverpod Provider Examples'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Available Providers:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('• bidsProvider - List bids with filters'),
              const Text('• bidDetailsProvider - Get bid details by ID'),
              const Text(
                  '• smartPricingProvider - Get AI pricing by service ID'),
              const Text('• pendingBidsProvider - Get all pending bids'),
              const Text('• acceptedBidsProvider - Get all accepted bids'),
              const Text('• myBidsProvider - Get user-specific bids'),
              const SizedBox(height: 16),
              const Text('Example Usage in Widget:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '''
Consumer(
  builder: (context, ref, child) {
    final bidsAsync = ref.watch(bidsProvider(null));
    
    return bidsAsync.when(
      data: (bids) => ListView.builder(
        itemCount: bids.length,
        itemBuilder: (context, index) {
          final bid = bids[index];
          return ListTile(
            title: Text('\${bid.amount} \${bid.currency}'),
            subtitle: Text(bid.message),
            trailing: Text(bid.status),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: \$error'),
    );
  },
)
                  ''',
                  style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Example widget showing how to use Riverpod providers
class BidsListWidget extends ConsumerWidget {
  const BidsListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch pending bids
    final pendingBidsAsync = ref.watch(pendingBidsProvider);

    return pendingBidsAsync.when(
      data: (bids) => ListView.builder(
        itemCount: bids.length,
        itemBuilder: (context, index) {
          final bid = bids[index];
          return Card(
            child: ListTile(
              title: Text('${bid.amount} ${bid.currency}'),
              subtitle: Text(bid.message),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(bid.status),
                  Text(bid.createdAt.toString().split(' ')[0]),
                ],
              ),
              onTap: () {
                // Navigate to bid details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BidDetailsWidget(bidId: bid.id),
                  ),
                );
              },
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

/// Example widget for bid details
class BidDetailsWidget extends ConsumerWidget {
  final String bidId;

  const BidDetailsWidget({super.key, required this.bidId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bidAsync = ref.watch(bidDetailsProvider(bidId));

    return Scaffold(
      appBar: AppBar(title: const Text('Bid Details')),
      body: bidAsync.when(
        data: (bid) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amount: ${bid.amount} ${bid.currency}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Duration: ${bid.duration}'),
              const SizedBox(height: 8),
              Text('Status: ${bid.status}'),
              const SizedBox(height: 8),
              Text('Location: ${bid.location}'),
              const SizedBox(height: 16),
              const Text('Message:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(bid.message),
              const SizedBox(height: 16),
              if (bid.isAiSuggested) ...[
                const Text('🤖 This bid was created with AI assistance'),
                const SizedBox(height: 8),
              ],
              Text('Created: ${bid.createdAt.toString().split(' ')[0]}'),
              const SizedBox(height: 16),
              if (bid.status == 'pending') ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _acceptBid(context, ref, bid.id),
                        child: const Text('Accept'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _rejectBid(context, ref, bid.id),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text('Reject'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Future<void> _acceptBid(
      BuildContext context, WidgetRef ref, String bidId) async {
    final bidsService = ref.read(bidsServiceProvider);
    final request = AcceptBidRequest(
      bookingDate: DateTime.now().add(const Duration(days: 1)),
      paymentMethod: 'online',
    );

    final response = await bidsService.acceptBid(bidId, request);
    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bid accepted successfully!')),
      );
      // Refresh the bid details
      ref.invalidate(bidDetailsProvider(bidId));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.message}')),
      );
    }
  }

  Future<void> _rejectBid(
      BuildContext context, WidgetRef ref, String bidId) async {
    final bidsService = ref.read(bidsServiceProvider);
    final response = await bidsService.rejectBid(bidId);
    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bid rejected successfully!')),
      );
      // Refresh the bid details
      ref.invalidate(bidDetailsProvider(bidId));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.message}')),
      );
    }
  }
}
