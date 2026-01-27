import 'package:get/get.dart';

class HomeController extends GetxController {
  // Bottom nav current index
  var currentIndex = 0.obs;

  // Selected category tab index
  var selectedCategoryIndex = 0.obs;

  // Search query
  var searchQuery = ''.obs;

  // Upcoming sessions count (for badge)
  var upcomingSessionsCount = 2.obs;

  // Unread messages count (for badge)
  var unreadMessagesCount = 3.obs;

  // Unread notifications count
  var unreadNotificationsCount = 5.obs;

  // Sample trainers data
  var featuredTrainers = <Map<String, dynamic>>[].obs;

  // Upcoming bookings
  var upcomingBookings = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFeaturedTrainers();
    _loadUpcomingBookings();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void _loadFeaturedTrainers() {
    featuredTrainers.value = [
      {
        'id': '1',
        'name': 'John Smith',
        'specialty': 'Strength Training',
        'rating': 4.9,
        'reviews': 127,
        'pricePerHour': 45,
        'isAvailable': true,
        'image': 'https://images.unsplash.com/photo-1567013127542-490d757e51fc?w=400',
      },
      {
        'id': '2',
        'name': 'Sarah Johnson',
        'specialty': 'Yoga & Flexibility',
        'rating': 4.8,
        'reviews': 98,
        'pricePerHour': 40,
        'isAvailable': true,
        'image': 'https://images.unsplash.com/photo-1594381898411-846e7d193883?w=400',
      },
      {
        'id': '3',
        'name': 'Mike Chen',
        'specialty': 'HIIT & Cardio',
        'rating': 4.7,
        'reviews': 156,
        'pricePerHour': 50,
        'isAvailable': false,
        'image': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=400',
      },
    ];
  }

  void _loadUpcomingBookings() {
    upcomingBookings.value = [
      {
        'id': '1',
        'trainerName': 'John Smith',
        'sessionType': 'Strength Training',
        'date': 'Today',
        'time': '10:00 AM',
        'duration': '60 min',
        'status': 'confirmed',
      },
      {
        'id': '2',
        'trainerName': 'Sarah Johnson',
        'sessionType': 'Yoga Session',
        'date': 'Tomorrow',
        'time': '2:00 PM',
        'duration': '45 min',
        'status': 'pending',
      },
    ];
  }

  void navigateToTrainerDetails(String trainerId) {
    // TODO: Navigate to trainer details page
    Get.toNamed('/trainer/$trainerId');
  }

  void navigateToBookingDetails(String bookingId) {
    // TODO: Navigate to booking details page
    Get.toNamed('/booking/$bookingId');
  }

  void navigateToMessages() {
    // TODO: Navigate to messages page
    Get.toNamed('/messages');
  }

  void navigateToNotifications() {
    // TODO: Navigate to notifications page
    Get.toNamed('/notifications');
  }

  void navigateToSearch() {
    // TODO: Navigate to search page
    Get.toNamed('/search');
  }
}
