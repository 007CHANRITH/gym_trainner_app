import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_summary_controller.dart';

class ProfileSummaryView extends GetView<ProfileSummaryController> {
  const ProfileSummaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile Summary',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Review your information before continuing',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSummaryCard(
                      icon: Icons.person,
                      title: 'Gender',
                      value: 'Male',
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryCard(
                      icon: Icons.cake,
                      title: 'Age',
                      value: '25 years',
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryCard(
                      icon: Icons.monitor_weight,
                      title: 'Weight',
                      value: '70 kg',
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryCard(
                      icon: Icons.height,
                      title: 'Height',
                      value: '170 cm',
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryCard(
                      icon: Icons.sports_gymnastics,
                      title: 'Fitness Goal',
                      value: 'Muscle Gain',
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryCard(
                      icon: Icons.directions_run,
                      title: 'Activity Level',
                      value: 'Moderately Active',
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryCard(
                      icon: Icons.fitness_center,
                      title: 'Fitness Level',
                      value: 'Intermediate',
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => controller.goBack(),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side:
                          const BorderSide(color: Colors.indigo, width: 2),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.completeProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.indigo, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
