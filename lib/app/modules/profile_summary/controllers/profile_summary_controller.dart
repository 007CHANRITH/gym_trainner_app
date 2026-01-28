import 'package:get/get.dart';

class ProfileSummaryController extends GetxController {
  void completeProfile() {
    // Navigate to Home Dashboard
    Get.offNamed('/home');
  }

  void goBack() {
    Get.back();
  }
}
