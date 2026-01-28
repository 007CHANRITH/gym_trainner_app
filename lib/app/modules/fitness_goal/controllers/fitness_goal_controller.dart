import 'package:get/get.dart';

class FitnessGoalController extends GetxController {
  var selectedGoal = Rx<String?>(null);

  final goals = [
    {'id': 'weight_loss', 'label': 'Weight Loss', 'icon': '⚖️'},
    {'id': 'muscle_gain', 'label': 'Muscle Gain', 'icon': '💪'},
    {'id': 'endurance', 'label': 'Build Endurance', 'icon': '🏃'},
    {'id': 'flexibility', 'label': 'Improve Flexibility', 'icon': '🧘'},
  ];

  void selectGoal(String goal) {
    selectedGoal.value = goal;
  }

  void nextStep() {
    if (selectedGoal.value != null) {
      Get.toNamed('/activity-level');
    } else {
      Get.snackbar('Error', 'Please select your fitness goal');
    }
  }

  void goBack() {
    Get.back();
  }
}
