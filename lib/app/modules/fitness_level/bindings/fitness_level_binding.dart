import 'package:get/get.dart';
import '../controllers/fitness_level_controller.dart';

class FitnessLevelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FitnessLevelController>(
      () => FitnessLevelController(),
    );
  }
}
