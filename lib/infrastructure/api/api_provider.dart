import 'package:get/get.dart';
import 'package:gym_trainer/infrastructure/api/api_client.dart';
import 'package:gym_trainer/infrastructure/api/repositories.dart';

/// API Service Provider - handles all API service initialization
class ApiServiceProvider {
  /// Initialize all API services (call this in main.dart)
  static Future<void> initialize() async {
    // Initialize API Client
    final apiClient = ApiClient(
      baseUrl: 'https://gym-trainer-backend-9lxr.onrender.com/api/v1',
    );
    Get.put<ApiClient>(apiClient);

    // Initialize Repositories
    Get.put<UserRepository>(UserRepository(Get.find<ApiClient>()));
    Get.put<TrainerRepository>(TrainerRepository(Get.find<ApiClient>()));
    Get.put<BookingRepository>(BookingRepository(Get.find<ApiClient>()));
  }

  /// Cleanup services
  static void dispose() {
    Get.delete<ApiClient>();
    Get.delete<UserRepository>();
    Get.delete<TrainerRepository>();
    Get.delete<BookingRepository>();
  }
}
