import 'package:get/get.dart';

class TrainerAvailabilityController extends GetxController {
  // Days of the week with their availability status and times
  final Map<String, dynamic> availability =
      {
        'Mon': {'active': false.obs, 'startTime': '09:00', 'endTime': '17:00'},
        'Tue': {'active': false.obs, 'startTime': '09:00', 'endTime': '17:00'},
        'Wed': {'active': false.obs, 'startTime': '09:00', 'endTime': '17:00'},
        'Thu': {'active': false.obs, 'startTime': '09:00', 'endTime': '17:00'},
        'Fri': {'active': false.obs, 'startTime': '09:00', 'endTime': '17:00'},
        'Sat': {'active': false.obs, 'startTime': '10:00', 'endTime': '16:00'},
        'Sun': {'active': false.obs, 'startTime': '10:00', 'endTime': '16:00'},
      }.obs;

  final activeCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _updateActiveCount();
  }

  void toggleDay(String day) {
    availability[day]!['active'].toggle();
    _updateActiveCount();
  }

  void setStartTime(String day, String time) {
    availability[day]!['startTime'] = time;
  }

  void setEndTime(String day, String time) {
    availability[day]!['endTime'] = time;
  }

  void _updateActiveCount() {
    activeCount.value =
        availability.values.where((day) => day['active'].value == true).length;
  }

  void saveAvailability() {
    // TODO: Implement saving to Firestore
    Get.snackbar(
      'Success',
      'Availability saved! ${activeCount.value} days active.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
