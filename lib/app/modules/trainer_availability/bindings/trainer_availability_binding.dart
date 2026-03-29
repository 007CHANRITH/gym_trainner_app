import 'package:get/get.dart';
import '../controllers/trainer_availability_controller.dart';

class TrainerAvailabilityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainerAvailabilityController>(
      () => TrainerAvailabilityController(),
    );
  }
}
