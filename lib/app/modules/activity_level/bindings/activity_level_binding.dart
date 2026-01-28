import 'package:get/get.dart';
import '../controllers/activity_level_controller.dart';

class ActivityLevelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityLevelController>(
      () => ActivityLevelController(),
    );
  }
}
