import 'package:get/get.dart';
import '../controllers/profile_summary_controller.dart';

class ProfileSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSummaryController>(
      () => ProfileSummaryController(),
    );
  }
}
