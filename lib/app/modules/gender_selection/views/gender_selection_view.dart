import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/gender_selection_controller.dart';

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

class GenderSelectionView extends GetView<GenderSelectionController> {
  const GenderSelectionView({Key? key}) : super(key: key);

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
        title: const Text(
          'Your Gender',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What is your gender?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'This helps us personalize your fitness experience',
              style: TextStyle(fontSize: 14, color: muted),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Column(
                children: [
                  _buildGenderOption(label: 'Male', value: 'male', icon: CupertinoIcons.person),
                  const SizedBox(height: 16),
                  _buildGenderOption(label: 'Female', value: 'female', icon: CupertinoIcons.person),
                  const SizedBox(height: 16),
                  _buildGenderOption(label: 'Other', value: 'other', icon: CupertinoIcons.person_2),
                ],
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

  Widget _buildGenderOption({required String label, required String value, required IconData icon}) {
    return Obx(() {
      final isSelected = controller.selectedGender.value == value;
      return GestureDetector(
        onTap: () => controller.selectGender(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: isSelected ? neon : stroke, width: 2),
            borderRadius: BorderRadius.circular(14),
            color: isSelected ? neon.withOpacity(0.1) : card,
          ),
          child: Row(
            children: [
              Icon(icon, size: 32, color: isSelected ? neon : muted),
              const SizedBox(width: 16),
              Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isSelected ? neon : Colors.white)),
              const Spacer(),
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
  }
}
