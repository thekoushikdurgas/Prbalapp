import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

/// Enhanced Service Service class
class EnhancedServiceService {
  final ApiService _apiService;

  EnhancedServiceService(this._apiService);

  /// List all services - GET /api/v1/services/
  Future<ApiResponse<List<Map<String, dynamic>>>> getServices() async {
    final response = await _apiService.get<List<Map<String, dynamic>>>(
      '/services/',
      fromJson: (json) {
        final results = json['results'] as List?;
        if (results != null) {
          return results.cast<Map<String, dynamic>>();
        }
        return <Map<String, dynamic>>[];
      },
    );
    return response;
  }

  /// Get nearby services - GET /api/v1/services/nearby/
  Future<ApiResponse<List<Map<String, dynamic>>>> getNearbyServices({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  }) async {
    final queryParams = <String, String>{
      'lat': latitude.toString(),
      'lng': longitude.toString(),
      'radius': radius.toString(),
    };

    final response = await _apiService.get<List<Map<String, dynamic>>>(
      '/services/nearby/',
      queryParameters: queryParams,
      fromJson: (json) {
        final results = json['results'] as List?;
        if (results != null) {
          return results.cast<Map<String, dynamic>>();
        }
        return <Map<String, dynamic>>[];
      },
    );
    return response;
  }

  /// Get trending services - GET /api/v1/services/trending/
  Future<ApiResponse<List<Map<String, dynamic>>>> getTrendingServices() async {
    final response = await _apiService.get<List<Map<String, dynamic>>>(
      '/services/trending/',
      fromJson: (json) {
        final results = json['results'] as List?;
        if (results != null) {
          return results.cast<Map<String, dynamic>>();
        }
        return <Map<String, dynamic>>[];
      },
    );
    return response;
  }
}

/// Provider for EnhancedServiceService
final enhancedServiceServiceProvider = Provider<EnhancedServiceService>((ref) {
  return EnhancedServiceService(ApiService());
});
