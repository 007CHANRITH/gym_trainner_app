import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fitness_level_controller.dart';

class FitnessLevelView extends GetView<FitnessLevelController> {
  const FitnessLevelView({Key? key}) : super(key: key);

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
          'Fitness Level',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What is your fitness level?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Help us tailor workouts to your experience',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: controller.levels.length,
                itemBuilder: (context, index) {
                  final level = controller.levels[index];
                  return Obx(
                    () => GestureDetector(
                      onTap: () =>
                          controller.selectLevel(level['id'] as String),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: controller.selectedLevel.value ==
                                level['id']
                                ? Colors.indigo
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: controller.selectedLevel.value ==
                              level['id']
                              ? Colors.indigo.withOpacity(0.1)
                              : Colors.white,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    level['label'] as String,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: controller.selectedLevel.value ==
                                          level['id']
                                          ? Colors.indigo
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    level['description'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Radio<String>(
                              value: level['id'] as String,
                              groupValue: controller.selectedLevel.value,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller.selectLevel(newValue);
                                }
                              },
                              activeColor: Colors.indigo,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
