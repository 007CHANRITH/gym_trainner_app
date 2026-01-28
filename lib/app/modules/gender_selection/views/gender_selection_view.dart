import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/gender_selection_controller.dart';

class GenderSelectionView extends GetView<GenderSelectionController> {
  const GenderSelectionView({Key? key}) : super(key: key);

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
          'Your Gender',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What is your gender?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'This helps us personalize your fitness experience',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Column(
                children: [
                  _buildGenderOption(
                    label: 'Male',
                    value: 'male',
                    icon: Icons.male,
                  ),
                  const SizedBox(height: 16),
                  _buildGenderOption(
                    label: 'Female',
                    value: 'female',
                    icon: Icons.female,
                  ),
                  const SizedBox(height: 16),
                  _buildGenderOption(
                    label: 'Other',
                    value: 'other',
                    icon: Icons.wc,
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

  Widget _buildGenderOption({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectGender(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: controller.selectedGender.value == value
                  ? Colors.indigo
                  : Colors.grey[300]!,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
            color: controller.selectedGender.value == value
                ? Colors.indigo.withOpacity(0.1)
                : Colors.white,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: controller.selectedGender.value == value
                    ? Colors.indigo
                    : Colors.grey,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: controller.selectedGender.value == value
                      ? Colors.indigo
                      : Colors.black,
                ),
              ),
              const Spacer(),
              Radio<String>(
                value: value,
                groupValue: controller.selectedGender.value,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.selectGender(newValue);
                  }
                },
                activeColor: Colors.indigo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
