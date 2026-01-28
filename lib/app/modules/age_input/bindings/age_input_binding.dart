import 'package:get/get.dart';
import '../controllers/age_input_controller.dart';

class AgeInputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgeInputController>(
      () => AgeInputController(),
    );
  }
}
