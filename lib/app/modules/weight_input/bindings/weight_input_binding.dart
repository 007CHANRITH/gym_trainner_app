import 'package:get/get.dart';
import '../controllers/weight_input_controller.dart';

class WeightInputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeightInputController>(
      () => WeightInputController(),
    );
  }
}
