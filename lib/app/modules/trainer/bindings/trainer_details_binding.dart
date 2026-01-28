import 'package:get/get.dart';
import '../controllers/trainer_details_controller.dart';

class TrainerDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainerDetailsController>(() => TrainerDetailsController());
  }
}
