import 'package:get/get.dart';
import 'package:gym_trainer/infrastructure/api/repositories.dart';

/// Example: Trainers Controller using API Repository
/// This shows how to integrate the professional API pattern
class TrainersController extends GetxController {
  final _trainerRepo = Get.find<TrainerRepository>();

  // Reactive variables
  final isLoading = false.obs;
  final trainers = <TrainerDto>[].obs;
  final error = ''.obs;
  final currentPage = 1.obs;
  final hasMore = false.obs;

  // Filters
  final selectedSpecialization = ''.obs;
  final selectedLocation = ''.obs;
  final minRating = 0.0.obs;

  @override
  void onReady() {
    super.onReady();
    fetchTrainers();
  }

  /// Fetch trainers with current filters
  Future<void> fetchTrainers({int? page}) async {
    isLoading(true);
    error('');
    currentPage(page ?? 1);

    try {
      final response = await _trainerRepo.getTrainers(
        specialization:
            selectedSpecialization.value.isEmpty
                ? null
                : selectedSpecialization.value,
        location:
            selectedLocation.value.isEmpty ? null : selectedLocation.value,
        minRating: minRating.value > 0 ? minRating.value : null,
        page: currentPage.value,
        pageSize: 20,
      );

      if (response.success && response.data != null) {
        if (currentPage.value == 1) {
          trainers.assignAll(response.data!.items);
        } else {
          trainers.addAll(response.data!.items);
        }
        hasMore(response.data!.hasMore);
      } else {
        error.value = response.error ?? 'Failed to load trainers';
      }
    } catch (e) {
      error.value = 'Error: ${e.toString()}';
      print('Error fetching trainers: $e');
    } finally {
      isLoading(false);
    }
  }

  /// Load more trainers (pagination)
  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;
    await fetchTrainers(page: currentPage.value + 1);
  }

  /// Apply filter and refresh
  Future<void> applyFilters({
    String? specialization,
    String? location,
    double? rating,
  }) async {
    selectedSpecialization(specialization ?? '');
    selectedLocation(location ?? '');
    minRating(rating ?? 0.0);
    currentPage(1);
    await fetchTrainers();
  }

  /// Reset filters
  Future<void> resetFilters() async {
    selectedSpecialization('');
    selectedLocation('');
    minRating(0.0);
    currentPage(1);
    await fetchTrainers();
  }

  /// Search trainers
  Future<void> search(String query) async {
    isLoading(true);
    error('');

    try {
      final response = await _trainerRepo.getTrainers(page: 1, pageSize: 20);

      if (response.success && response.data != null) {
        // Client-side filtering by name
        final q = query.toLowerCase();
        final filtered =
            response.data!.items
                .where(
                  (trainer) =>
                      trainer.name.toLowerCase().contains(q) ||
                      trainer.specialization.toLowerCase().contains(q),
                )
                .toList();

        trainers.assignAll(filtered);
      } else {
        error.value = response.error ?? 'Search failed';
      }
    } catch (e) {
      error.value = 'Error: ${e.toString()}';
    } finally {
      isLoading(false);
    }
  }
}

/// Example: Trainer Details Controller
class TrainerDetailsController extends GetxController {
  final _trainerRepo = Get.find<TrainerRepository>();

  final trainerId = ''.obs;
  final availability = Rxn<TrainerAvailabilityDto>();
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    trainerId(Get.arguments as String? ?? '');
  }

  @override
  void onReady() {
    super.onReady();
    if (trainerId.value.isNotEmpty) {
      fetchAvailability();
    }
  }

  /// Fetch trainer availability
  Future<void> fetchAvailability() async {
    isLoading(true);
    error('');

    try {
      final response = await _trainerRepo.getAvailability(trainerId.value);

      if (response.success && response.data != null) {
        availability.value = response.data;
      } else {
        error.value = response.error ?? 'Failed to load availability';
      }
    } catch (e) {
      error.value = 'Error: ${e.toString()}';
    } finally {
      isLoading(false);
    }
  }
}

/// Example: Bookings Controller using API
class BookingsController extends GetxController {
  final _bookingRepo = Get.find<BookingRepository>();

  final bookings = <BookingDto>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final selectedStatus = 'upcoming'.obs;

  @override
  void onReady() {
    super.onReady();
    fetchBookings();
  }

  /// Fetch user's bookings
  Future<void> fetchBookings() async {
    isLoading(true);
    error('');

    try {
      final response = await _bookingRepo.getBookings(
        status: selectedStatus.value,
      );

      if (response.success && response.data != null) {
        bookings.assignAll(response.data!.items);
      } else {
        error.value = response.error ?? 'Failed to load bookings';
      }
    } catch (e) {
      error.value = 'Error: ${e.toString()}';
    } finally {
      isLoading(false);
    }
  }

  /// Create new booking
  Future<bool> createBooking({
    required String trainerId,
    required DateTime scheduledAt,
    required int duration,
  }) async {
    isLoading(true);

    try {
      final request = CreateBookingRequest(
        trainerId: trainerId,
        scheduledAt: scheduledAt,
        durationMinutes: duration,
      );

      final response = await _bookingRepo.createBooking(request);

      if (response.success) {
        Get.snackbar('Success', 'Booking created successfully');
        await fetchBookings();
        return true;
      } else {
        Get.snackbar('Error', response.error ?? 'Booking failed');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading(false);
    }
  }

  /// Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      final response = await _bookingRepo.cancelBooking(bookingId);

      if (response.success) {
        Get.snackbar('Success', 'Booking cancelled');
        bookings.removeWhere((b) => b.id == bookingId);
      } else {
        Get.snackbar('Error', response.error ?? 'Cancellation failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  /// Filter by status
  Future<void> filterByStatus(String status) async {
    selectedStatus(status);
    await fetchBookings();
  }
}
