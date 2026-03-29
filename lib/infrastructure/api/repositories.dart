import 'package:gym_trainer/infrastructure/api/api_client.dart';
import 'package:gym_trainer/infrastructure/api/api_models.dart';

/// User Repository - handles all user-related APIs
class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  /// Get user profile
  Future<ApiResponse<UserProfileDto>> getProfile() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.usersProfile,
      );

      return ApiResponse.fromJson(
        response as Map<String, dynamic>,
        (json) => UserProfileDto.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse(success: false, error: e.toString());
    }
  }

  /// Update user profile
  Future<ApiResponse<UserProfileDto>> updateProfile(
    UpdateProfileRequest request,
  ) async {
    try {
      final response = await _apiClient.put<Map<String, dynamic>>(
        ApiConstants.usersUpdate,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response as Map<String, dynamic>,
        (json) => UserProfileDto.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse(success: false, error: e.toString());
    }
  }

  /// Search users
  Future<ApiResponse<PaginatedResponse<UserProfileDto>>> searchUsers({
    required String? query,
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.usersSearch,
        queryParameters: {'q': query, 'page': page, 'pageSize': pageSize},
      );

      return ApiResponse.fromJson(
        response as Map<String, dynamic>,
        (json) => PaginatedResponse.fromJson(
          json as Map<String, dynamic>,
          (item) => UserProfileDto.fromJson(item as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return ApiResponse(success: false, error: e.toString());
    }
  }
}

/// Trainer Repository - handles trainer-related APIs
class TrainerRepository {
  final ApiClient _apiClient;

  TrainerRepository(this._apiClient);

  /// Get all trainers with filters
  Future<ApiResponse<PaginatedResponse<TrainerDto>>> getTrainers({
    String? specialization,
    String? location,
    double? minRating,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.trainersGet,
        queryParameters: {
          'specialization': specialization,
          'location': location,
          'minRating': minRating,
          'page': page,
          'pageSize': pageSize,
        },
      );

      return ApiResponse.fromJson(
        response as Map<String, dynamic>,
        (json) => PaginatedResponse.fromJson(
          json as Map<String, dynamic>,
          (item) => TrainerDto.fromJson(item as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return ApiResponse(success: false, error: e.toString());
    }
  }

  /// Apply to become trainer
  Future<ApiResponse<TrainerApplicationDto>> applyAsTrainer(
    TrainerApplicationRequest request,
  ) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.trainersApply,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response as Map<String, dynamic>,
        (json) => TrainerApplicationDto.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse(success: false, error: e.toString());
    }
  }

  /// Get trainer availability
  Future<ApiResponse<TrainerAvailabilityDto>> getAvailability(
    String trainerId,
  ) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '${ApiConstants.trainersAvailability}/$trainerId',
      );

      return ApiResponse.fromJson(
        response as Map<String, dynamic>,
        (json) => TrainerAvailabilityDto.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse(success: false, error: e.toString());
    }
  }
}

/// Booking Repository - handles booking-related APIs
class BookingRepository {
  final ApiClient _apiClient;

  BookingRepository(this._apiClient);

  /// Create new booking
  Future<ApiResponse<BookingDto>> createBooking(
    CreateBookingRequest request,
  ) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.bookingsCreate,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response as Map<String, dynamic>,
        (json) => BookingDto.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse(success: false, error: e.toString());
    }
  }

  /// Get user's bookings
  Future<ApiResponse<PaginatedResponse<BookingDto>>> getBookings({
    String? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.bookingsGet,
        queryParameters: {'status': status, 'page': page, 'pageSize': pageSize},
      );

      return ApiResponse.fromJson(
        response as Map<String, dynamic>,
        (json) => PaginatedResponse.fromJson(
          json as Map<String, dynamic>,
          (item) => BookingDto.fromJson(item as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return ApiResponse(success: false, error: e.toString());
    }
  }

  /// Cancel booking
  Future<ApiResponse<dynamic>> cancelBooking(String bookingId) async {
    try {
      final response = await _apiClient.delete<Map<String, dynamic>>(
        ApiConstants.bookingsCancel.replaceFirst('{id}', bookingId),
      );

      return ApiResponse.fromJson(response as Map<String, dynamic>, null);
    } catch (e) {
      return ApiResponse(success: false, error: e.toString());
    }
  }
}

// ────────────────────────────────────────────────────────────────────────────
// DATA TRANSFER OBJECTS (DTOs)
// ────────────────────────────────────────────────────────────────────────────

class UserProfileDto {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String role;
  final Map<String, dynamic>? fitnessProfile;
  final DateTime createdAt;

  UserProfileDto({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.role,
    this.fitnessProfile,
    required this.createdAt,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      role: json['role'] as String,
      fitnessProfile: json['fitnessProfile'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class TrainerDto {
  final String id;
  final String name;
  final String bio;
  final String specialization;
  final double rating;
  final int reviewCount;
  final double hourlyRate;
  final String? photoUrl;

  TrainerDto({
    required this.id,
    required this.name,
    required this.bio,
    required this.specialization,
    required this.rating,
    required this.reviewCount,
    required this.hourlyRate,
    this.photoUrl,
  });

  factory TrainerDto.fromJson(Map<String, dynamic> json) {
    return TrainerDto(
      id: json['id'] as String,
      name: json['name'] as String,
      bio: json['bio'] as String,
      specialization: json['specialization'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble() ?? 0.0,
      photoUrl: json['photoUrl'] as String?,
    );
  }
}

class BookingDto {
  final String id;
  final String userId;
  final String trainerId;
  final DateTime scheduledAt;
  final int durationMinutes;
  final double price;
  final String status;

  BookingDto({
    required this.id,
    required this.userId,
    required this.trainerId,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.price,
    required this.status,
  });

  factory BookingDto.fromJson(Map<String, dynamic> json) {
    return BookingDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      trainerId: json['trainerId'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      durationMinutes: json['durationMinutes'] as int,
      price: (json['price'] as num).toDouble(),
      status: json['status'] as String,
    );
  }
}

class TrainerApplicationDto {
  final String id;
  final String userId;
  final String status;
  final DateTime submittedAt;

  TrainerApplicationDto({
    required this.id,
    required this.userId,
    required this.status,
    required this.submittedAt,
  });

  factory TrainerApplicationDto.fromJson(Map<String, dynamic> json) {
    return TrainerApplicationDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      status: json['status'] as String,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
    );
  }
}

class TrainerAvailabilityDto {
  final String trainerId;
  final List<AvailabilitySlot> slots;

  TrainerAvailabilityDto({required this.trainerId, required this.slots});

  factory TrainerAvailabilityDto.fromJson(Map<String, dynamic> json) {
    return TrainerAvailabilityDto(
      trainerId: json['trainerId'] as String,
      slots:
          (json['slots'] as List<dynamic>?)
              ?.map((s) => AvailabilitySlot.fromJson(s as Map<String, dynamic>))
              .toList() ??
          <AvailabilitySlot>[],
    );
  }
}

class AvailabilitySlot {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;

  AvailabilitySlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlot(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      isAvailable: json['isAvailable'] as bool,
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// REQUEST MODELS
// ────────────────────────────────────────────────────────────────────────────

class UpdateProfileRequest {
  final String name;
  final String? bio;
  final String? photoUrl;
  final Map<String, dynamic>? fitnessProfile;

  UpdateProfileRequest({
    required this.name,
    this.bio,
    this.photoUrl,
    this.fitnessProfile,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'bio': bio,
    'photoUrl': photoUrl,
    'fitnessProfile': fitnessProfile,
  };
}

class TrainerApplicationRequest {
  final String bio;
  final String specialization;
  final List<String> certifications;
  final double hourlyRate;

  TrainerApplicationRequest({
    required this.bio,
    required this.specialization,
    required this.certifications,
    required this.hourlyRate,
  });

  Map<String, dynamic> toJson() => {
    'bio': bio,
    'specialization': specialization,
    'certifications': certifications,
    'hourlyRate': hourlyRate,
  };
}

class CreateBookingRequest {
  final String trainerId;
  final DateTime scheduledAt;
  final int durationMinutes;

  CreateBookingRequest({
    required this.trainerId,
    required this.scheduledAt,
    required this.durationMinutes,
  });

  Map<String, dynamic> toJson() => {
    'trainerId': trainerId,
    'scheduledAt': scheduledAt.toIso8601String(),
    'durationMinutes': durationMinutes,
  };
}
