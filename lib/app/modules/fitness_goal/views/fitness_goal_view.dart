import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/fitness_goal_controller.dart';

// ─── Design Tokens (matching home_view) ────────────────────────────────────
const Color ink = Color(0xFF0A0A0F);
const Color surface = Color(0xFF111118);
const Color card = Color(0xFF17171F);
const Color raised = Color(0xFF1E1E28);
const Color stroke = Color(0xFF2A2A36);
const Color neon = Color(0xFFCBFF47);
const Color coral = Color(0xFFFF5C5C);
const Color sky = Color(0xFF5CE8FF);
const Color lilac = Color(0xFFA78BFA);
const Color muted = Color(0xFF6B6B7E);

class FitnessGoalView extends GetView<FitnessGoalController> {
  const FitnessGoalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ink,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => controller.goBack(),
        ),
        centerTitle: true,
        title: const Text('Fitness Goal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('What is your fitness goal?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            Text('Choose the goal that matters most to you', style: TextStyle(fontSize: 14, color: muted)),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: controller.goals.length,
                itemBuilder: (context, index) {
                  final goal = controller.goals[index];
                  return Obx(() {
                    final isSelected = controller.selectedGoal.value == goal['id'];
                    return GestureDetector(
                      onTap: () => controller.selectGoal(goal['id'] as String),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: isSelected ? neon : stroke, width: 2),
                          borderRadius: BorderRadius.circular(14),
                          color: isSelected ? neon.withOpacity(0.1) : card,
                        ),
                        child: Row(
                          children: [
                            Text(goal['icon'] as String, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(goal['label'] as String,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isSelected ? neon : Colors.white)),
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: isSelected ? neon : stroke, width: 2),
                                color: isSelected ? neon : Colors.transparent,
                              ),
                              child: isSelected ? const Icon(CupertinoIcons.checkmark, color: ink, size: 16) : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => controller.nextStep(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: neon,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ink)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
