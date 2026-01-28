import 'package:get/get.dart';

class ActivityLevelController extends GetxController {
  var selectedLevel = Rx<String?>(null);

  final levels = [
    {'id': 'sedentary', 'label': 'Sedentary', 'description': 'Little or no exercise'},
    {'id': 'lightly_active', 'label': 'Lightly Active', 'description': '1-3 days per week'},
    {'id': 'moderately_active', 'label': 'Moderately Active', 'description': '3-5 days per week'},
    {'id': 'very_active', 'label': 'Very Active', 'description': '6-7 days per week'},
  ];

  void selectLevel(String level) {
    selectedLevel.value = level;
  }

  void nextStep() {
    if (selectedLevel.value != null) {
      Get.toNamed('/fitness-level');
    } else {
      Get.snackbar('Error', 'Please select your activity level');
    }
  }

  void goBack() {
    Get.back();
  }
}
