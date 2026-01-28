import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AgeInputController extends GetxController {
  var age = Rx<int?>(null);
  final ageController = TextEditingController();

  void setAge(int value) {
    age.value = value;
    ageController.text = value.toString();
  }

  void nextStep() {
    if (age.value != null && age.value! > 0 && age.value! < 150) {
      Get.toNamed('/weight-input');
    } else {
      Get.snackbar('Error', 'Please enter a valid age');
    }
  }

  void goBack() {
    Get.back();
  }

  @override
  void onClose() {
    ageController.dispose();
    super.onClose();
  }
}
