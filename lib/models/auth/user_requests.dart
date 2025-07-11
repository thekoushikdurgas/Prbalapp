import 'user_type.dart';

/// User profile update request
class UpdateProfileRequest {
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? bio;
  final String? location;

  const UpdateProfileRequest({
    this.username,
    this.firstName,
    this.lastName,
    this.bio,
    this.location,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (username != null) json['username'] = username;
    if (firstName != null) json['first_name'] = firstName;
    if (lastName != null) json['last_name'] = lastName;
    if (bio != null) json['bio'] = bio;
    if (location != null) json['location'] = location;
    return json;
  }
}

/// User search request
class UserSearchRequest {
  final String? searchTerm;
  final List<UserType>? userTypes;
  final String? location;
  final double? minRating;
  final int? page;
  final int? pageSize;

  const UserSearchRequest({
    this.searchTerm,
    this.userTypes,
    this.location,
    this.minRating,
    this.page = 1,
    this.pageSize = 10,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (searchTerm != null) json['search_term'] = searchTerm;
    if (userTypes != null) {
      json['user_types'] = userTypes!.map((type) => type.name).toList();
    }
    if (location != null) json['location'] = location;
    if (minRating != null) json['min_rating'] = minRating;
    if (page != null) json['page'] = page;
    if (pageSize != null) json['page_size'] = pageSize;
    return json;
  }
}
