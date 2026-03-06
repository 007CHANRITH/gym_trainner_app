import 'package:get/get.dart';

class ProfileSummaryController extends GetxController {
  void completeProfile() {
    // Navigate to Home Dashboard and clear all previous routes
    Get.offAllNamed('/home');
  }

  void goBack() {
    Get.back();
  }
}
