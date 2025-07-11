/// Paginated response model for list endpoints
/// Used by APIs that return lists of data with pagination support
///
/// Standard pagination format from Django REST Framework:
/// {
///   "count": 150,
///   "next": "http://api.example.org/accounts/?page=4",
///   "previous": "http://api.example.org/accounts/?page=2",
///   "results": [...]
/// }
class PaginatedResponse<T> {
  final List<T> results;
  final int count;
  final String? next;
  final String? previous;
  final int page;
  final int pageSize;
  final int totalPages;

  const PaginatedResponse({
    required this.results,
    required this.count,
    this.next,
    this.previous,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final results = (json['results'] as List<dynamic>)
        .map((item) => fromJsonT(item as Map<String, dynamic>))
        .toList();

    final count = json['count'] as int;
    final pageSize = results.isNotEmpty ? results.length : 20; // fallback
    final totalPages = (count / pageSize).ceil();

    // Extract page number from URLs
    int currentPage = 1;
    if (json['next'] != null) {
      final nextUrl = json['next'] as String;
      final nextPageMatch = RegExp(r'page=(\d+)').firstMatch(nextUrl);
      if (nextPageMatch != null) {
        currentPage = int.parse(nextPageMatch.group(1)!) - 1;
      }
    } else if (json['previous'] != null) {
      final prevUrl = json['previous'] as String;
      final prevPageMatch = RegExp(r'page=(\d+)').firstMatch(prevUrl);
      if (prevPageMatch != null) {
        currentPage = int.parse(prevPageMatch.group(1)!) + 1;
      }
    }

    return PaginatedResponse<T>(
      results: results,
      count: count,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      page: currentPage,
      pageSize: pageSize,
      totalPages: totalPages,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'results': results.map((item) => toJsonT(item)).toList(),
      'count': count,
      if (next != null) 'next': next,
      if (previous != null) 'previous': previous,
      'page': page,
      'page_size': pageSize,
      'total_pages': totalPages,
    };
  }

  bool get hasNext => next != null;
  bool get hasPrevious => previous != null;
  bool get isEmpty => results.isEmpty;
  bool get isNotEmpty => results.isNotEmpty;

  @override
  String toString() {
    return 'PaginatedResponse<$T>(count: $count, page: $page/$totalPages, results: ${results.length})';
  }
}
