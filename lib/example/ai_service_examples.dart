// This file demonstrates how to use the AI services in your Flutter app
// Remove this file once you've integrated the services into your actual screens

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbal/services/ai_service.dart';

/// AI Suggestions Screen - Demonstrates listing and interacting with AI suggestions
class DurgasAISuggestionsScreen extends ConsumerStatefulWidget {
  const DurgasAISuggestionsScreen({super.key});

  @override
  ConsumerState<DurgasAISuggestionsScreen> createState() =>
      _DurgasAISuggestionsScreenState();
}

class _DurgasAISuggestionsScreenState
    extends ConsumerState<DurgasAISuggestionsScreen> {
  String? _selectedType;
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    // Create filters map for the provider
    final filters = <String, String>{};
    if (_selectedType != null) filters['suggestion_type'] = _selectedType!;
    if (_selectedStatus != null) filters['status'] = _selectedStatus!;

    final suggestionsAsync =
        ref.watch(aiSuggestionsProvider(filters.isEmpty ? null : filters));

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Suggestions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter display
          if (_selectedType != null || _selectedStatus != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  if (_selectedType != null)
                    Chip(
                      label: Text('Type: $_selectedType'),
                      onDeleted: () => setState(() => _selectedType = null),
                    ),
                  if (_selectedStatus != null)
                    Chip(
                      label: Text('Status: $_selectedStatus'),
                      onDeleted: () => setState(() => _selectedStatus = null),
                    ),
                ],
              ),
            ),

          // Suggestions list
          Expanded(
            child: suggestionsAsync.when(
              data: (suggestions) {
                if (suggestions.isEmpty) {
                  return const Center(child: Text('No suggestions available'));
                }

                return ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) =>
                      _buildSuggestionCard(suggestions[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $error'),
                    ElevatedButton(
                      onPressed: () => ref.refresh(aiSuggestionsProvider(
                          filters.isEmpty ? null : filters)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showGenerateServiceSuggestionsDialog,
        tooltip: 'Generate Service Suggestions',
        child: const Icon(Icons.auto_awesome),
      ),
    );
  }

  Widget _buildSuggestionCard(AISuggestion suggestion) {
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
                  child: Text(
                    suggestion.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Chip(
                  label: Text(suggestion.status.toUpperCase()),
                  backgroundColor: _getStatusColor(suggestion.status),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              suggestion.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Type: ${suggestion.suggestionType}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                if (suggestion.confidenceScore != null)
                  Text(
                    'Confidence: ${(suggestion.confidenceScore! * 100).toStringAsFixed(1)}%',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _viewSuggestionDetails(suggestion.id),
                  child: const Text('View Details'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _provideFeedback(suggestion.id),
                  child: const Text('Provide Feedback'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue.shade100;
      case 'viewed':
        return Colors.orange.shade100;
      case 'implemented':
        return Colors.green.shade100;
      case 'rejected':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Suggestions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'Suggestion Type'),
              items: const [
                DropdownMenuItem(
                    value: 'bid_amount', child: Text('Bid Amount')),
                DropdownMenuItem(value: 'pricing', child: Text('Pricing')),
                DropdownMenuItem(
                    value: 'service_improvement',
                    child: Text('Service Improvement')),
                DropdownMenuItem(value: 'marketing', child: Text('Marketing')),
              ],
              onChanged: (value) => setState(() => _selectedType = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(labelText: 'Status'),
              items: const [
                DropdownMenuItem(value: 'new', child: Text('New')),
                DropdownMenuItem(value: 'viewed', child: Text('Viewed')),
                DropdownMenuItem(
                    value: 'implemented', child: Text('Implemented')),
                DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
              ],
              onChanged: (value) => setState(() => _selectedStatus = value),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {}); // Trigger rebuild with new filters
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showGenerateServiceSuggestionsDialog() {
    final interestsController = TextEditingController();
    final locationController = TextEditingController();
    final budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Service Suggestions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: interestsController,
              decoration: const InputDecoration(
                labelText: 'Interests (comma separated)',
                hintText: 'home cleaning, gardening, repairs',
              ),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Bangalore, India',
              ),
            ),
            TextField(
              controller: budgetController,
              decoration: const InputDecoration(
                labelText: 'Budget Range',
                hintText: '₹500-2000',
              ),
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
              Navigator.pop(context);
              await _generateServiceSuggestions(
                interestsController.text,
                locationController.text,
                budgetController.text,
              );
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  Future<void> _generateServiceSuggestions(
    String interests,
    String location,
    String budget,
  ) async {
    try {
      final aiService = ref.read(aiServiceProvider);

      final request = ServiceSuggestionRequest(
        preferences: {
          'interests': interests.split(',').map((e) => e.trim()).toList(),
          'location': location,
          'budget': budget,
        },
        maxSuggestions: 5,
      );

      final response = await aiService.generateServiceSuggestions(request);

      if (response.success && response.data != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Generated ${response.data!.length} suggestions!'),
          ),
        );
        // Refresh the suggestions list
        // ignore: unused_result
        ref.refresh(aiSuggestionsProvider(null));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response.message ?? 'Failed to generate suggestions')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _viewSuggestionDetails(String suggestionId) async {
    try {
      final suggestion =
          await ref.read(aiSuggestionDetailsProvider(suggestionId).future);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(suggestion.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Description:',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(suggestion.description),
                const SizedBox(height: 16),
                Text('Type:',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(suggestion.suggestionType),
                const SizedBox(height: 16),
                Text('Status:',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(suggestion.status),
                if (suggestion.confidenceScore != null) ...[
                  const SizedBox(height: 16),
                  Text('Confidence Score:',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      '${(suggestion.confidenceScore! * 100).toStringAsFixed(1)}%'),
                ],
                if (suggestion.suggestionData != null) ...[
                  const SizedBox(height: 16),
                  Text('Additional Data:',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(suggestion.suggestionData.toString()),
                ],
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
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading details: $e')),
      );
    }
  }

  Future<void> _provideFeedback(String suggestionId) async {
    final feedbackController = TextEditingController();
    bool isUsed = false;
    String status = 'viewed';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Provide Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: feedbackController,
                decoration: const InputDecoration(labelText: 'Feedback'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('I used this suggestion'),
                value: isUsed,
                onChanged: (value) =>
                    setDialogState(() => isUsed = value ?? false),
              ),
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'viewed', child: Text('Viewed')),
                  DropdownMenuItem(
                      value: 'implemented', child: Text('Implemented')),
                  DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
                ],
                onChanged: (value) =>
                    setDialogState(() => status = value ?? 'viewed'),
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
                Navigator.pop(context);
                await _submitFeedback(
                    suggestionId, feedbackController.text, isUsed, status);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitFeedback(
    String suggestionId,
    String feedback,
    bool isUsed,
    String status,
  ) async {
    try {
      final aiService = ref.read(aiServiceProvider);

      final request = SuggestionFeedbackRequest(
        feedback: feedback,
        isUsed: isUsed,
        status: status,
      );

      final response =
          await aiService.provideFeedbackOnSuggestion(suggestionId, request);

      if (response.success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback submitted successfully!')),
        );
        // Refresh the suggestions list
        // ignore: unused_result
        ref.refresh(aiSuggestionsProvider(null));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message ?? 'Failed to submit feedback')),
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

/// Bid Assistance Screen - Demonstrates AI-powered bid suggestions
class DurgasBidAssistanceScreen extends ConsumerStatefulWidget {
  final String serviceId;
  final String? customerId;

  const DurgasBidAssistanceScreen({
    super.key,
    required this.serviceId,
    this.customerId,
  });

  @override
  ConsumerState<DurgasBidAssistanceScreen> createState() =>
      _DurgasBidAssistanceScreenState();
}

class _DurgasBidAssistanceScreenState
    extends ConsumerState<DurgasBidAssistanceScreen> {
  final _bidAmountController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoadingBidAmount = false;
  bool _isLoadingMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Bid Assistance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service ID: ${widget.serviceId}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Bid Amount Section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _bidAmountController,
                    decoration: const InputDecoration(
                      labelText: 'Bid Amount (₹)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _isLoadingBidAmount ? null : _suggestBidAmount,
                  icon: _isLoadingBidAmount
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: const Text('AI Suggest'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Message Section
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Bid Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoadingMessage ? null : _suggestBidMessage,
                    icon: _isLoadingMessage
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_awesome),
                    label: const Text('AI Suggest Message'),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _isLoadingMessage ? null : _suggestMessageTemplate,
                  icon: const Icon(Icons.description),
                  label: const Text('Template'),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitBid,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Submit Bid'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _suggestBidAmount() async {
    setState(() => _isLoadingBidAmount = true);

    try {
      final aiService = ref.read(aiServiceProvider);

      final request = BidAmountSuggestionRequest(serviceId: widget.serviceId);
      final response = await aiService.suggestBidAmount(request);

      if (response.success && response.data != null) {
        final suggestedAmount = response.data!['suggested_amount'];
        if (suggestedAmount != null) {
          _bidAmountController.text = suggestedAmount.toString();
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AI suggested bid amount!')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message ?? 'Failed to get suggestion')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoadingBidAmount = false);
    }
  }

  Future<void> _suggestBidMessage() async {
    if (widget.customerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Customer ID required for message suggestion')),
      );
      return;
    }

    if (_bidAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter bid amount first')),
      );
      return;
    }

    setState(() => _isLoadingMessage = true);

    try {
      final aiService = ref.read(aiServiceProvider);

      final request = BidMessageSuggestionRequest(
        serviceId: widget.serviceId,
        customerId: widget.customerId!,
        bidAmount: double.tryParse(_bidAmountController.text) ?? 0,
        messageTone: 'professional',
        timeframeDays: 7,
      );

      final response = await aiService.suggestBidMessage(request);

      if (response.success && response.data != null) {
        final suggestedMessage = response.data!['suggested_message'];
        if (suggestedMessage != null) {
          _messageController.text = suggestedMessage.toString();
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AI suggested bid message!')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message ?? 'Failed to get suggestion')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoadingMessage = false);
    }
  }

  Future<void> _suggestMessageTemplate() async {
    setState(() => _isLoadingMessage = true);

    try {
      final aiService = ref.read(aiServiceProvider);

      final request = MessageTemplateSuggestionRequest(
        serviceId: widget.serviceId,
        messageType: 'bid_proposal',
        preferences: {
          'tone': 'friendly',
          'include_experience': true,
        },
      );

      final response = await aiService.suggestMessageTemplate(request);

      if (response.success && response.data != null) {
        final template = response.data!['template'];
        if (template != null) {
          _messageController.text = template.toString();
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AI suggested message template!')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Failed to get template')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoadingMessage = false);
    }
  }

  Future<void> _submitBid() async {
    if (_bidAmountController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Here you would typically call your bid service to submit the bid
    // and then log the interaction with AI service

    try {
      final aiService = ref.read(aiServiceProvider);

      // Log that AI assistance was used for this bid
      final logRequest = InteractionLogRequest(
        interactionType: 'use',
        interactionData: {
          'outcome': 'bid_submitted',
          'service_id': widget.serviceId,
          'bid_amount': _bidAmountController.text,
          'ai_assisted': true,
        },
      );

      await aiService.logInteraction(logRequest);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bid submitted successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting bid: $e')),
      );
    }
  }

  @override
  void dispose() {
    _bidAmountController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

/// AI Feedback Logs Screen - View interaction logs with AI suggestions
class DurgasAIFeedbackLogsScreen extends ConsumerWidget {
  const DurgasAIFeedbackLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedbackLogsAsync = ref.watch(feedbackLogsProvider(false));

    return Scaffold(
      appBar: AppBar(title: const Text('AI Feedback Logs')),
      body: feedbackLogsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(child: Text('No feedback logs found'));
          }

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) => _buildLogCard(logs[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () => ref.refresh(feedbackLogsProvider(false)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogCard(AIFeedbackLog log) {
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
                  'Log #${log.id.substring(0, 8)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  log.createdAt.toLocal().toString().substring(0, 16),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Interaction Type: ${log.interactionType}'),
            if (log.suggestionId != null)
              Text('Suggestion ID: ${log.suggestionId!.substring(0, 8)}...'),
            if (log.bidId != null)
              Text('Bid ID: ${log.bidId!.substring(0, 8)}...'),
            const SizedBox(height: 8),
            Text(
              'Data: ${log.interactionData.toString()}',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}

/// Usage Instructions:
///
/// To integrate these AI features into your app:
///
/// 1. Import the AI service in your screens:
///    ```dart
///    import 'package:prbal/services/ai_service.dart';
///    ```
///
/// 2. Use the providers in your widgets:
///    ```dart
///    final suggestions = ref.watch(aiSuggestionsProvider(null));
///    ```
///
/// 3. Call AI service methods for interactions:
///    ```dart
///    final aiService = ref.read(aiServiceProvider);
///    final response = await aiService.suggestBidAmount(request);
///    ```
///
/// 4. Add these routes to your app router:
///    ```dart
///    '/ai-suggestions': (context) => const DurgasAISuggestionsScreen(),
///    '/bid-assistance': (context) => DurgasBidAssistanceScreen(serviceId: '...'),
///    '/ai-feedback-logs': (context) => const DurgasAIFeedbackLogsScreen(),
///    ```
