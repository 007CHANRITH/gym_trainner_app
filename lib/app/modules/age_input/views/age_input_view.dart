import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/age_input_controller.dart';

class AgeInputView extends GetView<AgeInputController> {
  const AgeInputView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => controller.goBack(),
        ),
        centerTitle: true,
        title: const Text(
          'Your Age',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How old are you?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'This helps us create age-appropriate workouts',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Text(
                      controller.age.value?.toString() ?? '0',
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Slider(
                    value: (controller.age.value ?? 20).toDouble(),
                    min: 13,
                    max: 100,
                    divisions: 87,
                    label: controller.age.value?.toString() ?? '20',
                    activeColor: Colors.indigo,
                    inactiveColor: Colors.indigo[100],
                    onChanged: (value) {
                      controller.setAge(value.toInt());
                    },
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: controller.ageController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        controller.setAge(int.parse(value));
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your age',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.indigo, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => controller.nextStep(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
