import 'package:get/get.dart';

class NotificationPermissionController extends GetxController {
  var notificationEnabled = Rx<bool>(false);

  void toggleNotification(bool value) {
    notificationEnabled.value = value;
  }

  void nextStep() {
    Get.toNamed('/profile-summary');
  }

  void goBack() {
    Get.back();
  }
}
