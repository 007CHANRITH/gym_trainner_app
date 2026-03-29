/// Standard API Response Envelope
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;
  final int? statusCode;
  final Map<String, dynamic>? metadata;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.statusCode = 200,
    this.metadata,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? dataDecoder,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      data:
          json['data'] != null && dataDecoder != null
              ? dataDecoder(json['data'])
              : null,
      message: json['message'] as String?,
      error: json['error'] as String?,
      statusCode: json['statusCode'] as int?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data,
    'message': message,
    'error': error,
    'statusCode': statusCode,
    'metadata': metadata,
  };
}

/// Paginated Response
class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;
  final String? nextCursor;

  PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasMore,
    this.nextCursor,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? itemDecoder,
  ) {
    final itemsList =
        (json['items'] as List<dynamic>?)
            ?.map((item) => itemDecoder != null ? itemDecoder(item) : item as T)
            .toList() ??
        <T>[];

    return PaginatedResponse(
      items: itemsList,
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      hasMore: json['hasMore'] as bool? ?? false,
      nextCursor: json['nextCursor'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items,
    'total': total,
    'page': page,
    'pageSize': pageSize,
    'hasMore': hasMore,
    'nextCursor': nextCursor,
  };
}

/// Standard Error Response
class ErrorResponse {
  final String message;
  final String code;
  final Map<String, dynamic>? details;
  final String? requestId;

  ErrorResponse({
    required this.message,
    required this.code,
    this.details,
    this.requestId,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'] as String? ?? 'Unknown error',
      code: json['code'] as String? ?? 'UNKNOWN_ERROR',
      details: json['details'] as Map<String, dynamic>?,
      requestId: json['requestId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'code': code,
    'details': details,
    'requestId': requestId,
  };
}

/// Request Builder for type-safe requests
class ApiRequest<T> {
  final String endpoint;
  final String method;
  final Map<String, dynamic>? queryParameters;
  final dynamic body;
  final Map<String, String>? headers;
  final T Function(dynamic)? decoder;

  ApiRequest({
    required this.endpoint,
    required this.method,
    this.queryParameters,
    this.body,
    this.headers,
    this.decoder,
  });
}

/// Response builder with validation
class ApiResponseBuilder<T> {
  final T Function(dynamic)? decoder;

  ApiResponseBuilder({this.decoder});

  ApiResponseBuilder<T> withValidation() {
    // JSON schema validation would go here if needed
    return this;
  }

  T? build(dynamic json) {
    if (json == null) return null;
    if (decoder == null) return json as T;
    return decoder!(json);
  }
}

/// API Constants
class ApiConstants {
  static const String baseUrl = 'https://your-backend-api.com/api/v1';

  // Auth endpoints
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authLogout = '/auth/logout';
  static const String authRefreshToken = '/auth/refresh-token';

  // User endpoints
  static const String usersProfile = '/users/profile';
  static const String usersSearch = '/users/search';
  static const String usersUpdate = '/users/profile';

  // Trainer endpoints
  static const String trainersGet = '/trainers';
  static const String trainersSearch = '/trainers/search';
  static const String trainersApply = '/trainers/applications';
  static const String trainersAvailability = '/trainers/availability';

  // Booking endpoints
  static const String bookingsCreate = '/bookings';
  static const String bookingsGet = '/bookings';
  static const String bookingsCancel = '/bookings/{id}/cancel';

  // Admin endpoints
  static const String adminUsers = '/admin/users';
  static const String adminApplications = '/admin/applications';
  static const String adminAnalytics = '/admin/analytics';

  // Payment endpoints
  static const String paymentWallet = '/payments/wallet';
  static const String paymentTransactions = '/payments/transactions';
}
