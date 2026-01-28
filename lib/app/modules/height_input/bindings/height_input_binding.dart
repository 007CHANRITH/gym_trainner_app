import 'package:get/get.dart';
import '../controllers/height_input_controller.dart';

class HeightInputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HeightInputController>(
      () => HeightInputController(),
    );
  }
}
