import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fitness_goal_controller.dart';

class FitnessGoalView extends GetView<FitnessGoalController> {
  const FitnessGoalView({Key? key}) : super(key: key);

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
          'Fitness Goal',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What is your fitness goal?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Choose the goal that matters most to you',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: controller.goals.length,
                itemBuilder: (context, index) {
                  final goal = controller.goals[index];
                  return Obx(
                    () => GestureDetector(
                      onTap: () => controller.selectGoal(goal['id'] as String),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                controller.selectedGoal.value == goal['id']
                                    ? Colors.indigo
                                    : Colors.grey[300]!,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color:
                              controller.selectedGoal.value == goal['id']
                                  ? Colors.indigo.withOpacity(0.1)
                                  : Colors.white,
                        ),
                        child: Row(
                          children: [
                            Text(
                              goal['icon'] as String,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                goal['label'] as String,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      controller.selectedGoal.value ==
                                          goal['id']
                                          ? Colors.indigo
                                          : Colors.black,
                                ),
                              ),
                            ),
                            Radio<String>(
                              value: goal['id'] as String,
                              groupValue: controller.selectedGoal.value,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller.selectGoal(newValue);
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
