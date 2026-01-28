import 'package:get/get.dart';

class TrainerDetailsController extends GetxController {
  // Add your observable variables and logic here
  var trainerId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get the trainer id from arguments
    if (Get.arguments != null && Get.arguments['id'] != null) {
      trainerId.value = Get.arguments['id'].toString();
    }
  }
}
