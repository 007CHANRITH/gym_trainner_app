import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weight_input_controller.dart';

class WeightInputView extends GetView<WeightInputController> {
  const WeightInputView({Key? key}) : super(key: key);

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
          'Your Weight',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What is your weight?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Enter your current weight in kg',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Text(
                      '${controller.weight.value ?? 70} kg',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Slider(
                    value: (controller.weight.value ?? 70).toDouble(),
                    min: 30,
                    max: 200,
                    divisions: 170,
                    label: '${controller.weight.value ?? 70} kg',
                    activeColor: Colors.indigo,
                    inactiveColor: Colors.indigo[100],
                    onChanged: (value) {
                      controller.setWeight(value.toInt());
                    },
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: controller.weightController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        controller.setWeight(int.parse(value));
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your weight (kg)',
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
