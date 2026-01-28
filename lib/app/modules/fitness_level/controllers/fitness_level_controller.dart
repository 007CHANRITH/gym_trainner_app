import 'package:get/get.dart';

class FitnessLevelController extends GetxController {
  var selectedLevel = Rx<String?>(null);

  final levels = [
    {'id': 'beginner', 'label': 'Beginner', 'description': 'Just starting out'},
    {'id': 'intermediate', 'label': 'Intermediate', 'description': 'Some experience'},
    {'id': 'advanced', 'label': 'Advanced', 'description': 'Very experienced'},
  ];

  void selectLevel(String level) {
    selectedLevel.value = level;
  }

  void nextStep() {
    if (selectedLevel.value != null) {
      Get.toNamed('/notification-permission');
    } else {
      Get.snackbar('Error', 'Please select your fitness level');
    }
  }

  void goBack() {
    Get.back();
  }
}
