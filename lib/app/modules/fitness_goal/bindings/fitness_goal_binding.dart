import 'package:get/get.dart';
import '../controllers/fitness_goal_controller.dart';

class FitnessGoalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FitnessGoalController>(
      () => FitnessGoalController(),
    );
  }
}
