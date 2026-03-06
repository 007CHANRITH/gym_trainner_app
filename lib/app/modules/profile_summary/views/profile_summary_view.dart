import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/profile_summary_controller.dart';

// ─── Design Tokens (matching home_view) ────────────────────────────────────────
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

class ProfileSummaryView extends GetView<ProfileSummaryController> {
  const ProfileSummaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ink,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
        title: const Text('Profile Summary', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            Text('Review your information before continuing', style: TextStyle(fontSize: 14, color: muted)),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSummaryCard(icon: CupertinoIcons.person_fill, title: 'Gender', value: 'Male', color: neon),
                    const SizedBox(height: 12),
                    _buildSummaryCard(icon: CupertinoIcons.gift, title: 'Age', value: '25 years', color: coral),
                    const SizedBox(height: 12),
                    _buildSummaryCard(icon: CupertinoIcons.gauge, title: 'Weight', value: '70 kg', color: sky),
                    const SizedBox(height: 12),
                    _buildSummaryCard(icon: CupertinoIcons.resize_v, title: 'Height', value: '170 cm', color: lilac),
                    const SizedBox(height: 12),
                    _buildSummaryCard(icon: CupertinoIcons.sportscourt, title: 'Fitness Goal', value: 'Muscle Gain', color: neon),
                    const SizedBox(height: 12),
                    _buildSummaryCard(icon: CupertinoIcons.bolt, title: 'Activity Level', value: 'Moderately Active', color: coral),
                    const SizedBox(height: 12),
                    _buildSummaryCard(icon: CupertinoIcons.sportscourt, title: 'Fitness Level', value: 'Intermediate', color: sky),
                  ],
                ),
              ),
               
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => controller.goBack(),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: const BorderSide(color: neon, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Edit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: neon)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.completeProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neon,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ink)),
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

  Widget _buildSummaryCard({required IconData icon, required String title, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: stroke),
        borderRadius: BorderRadius.circular(14),
        color: card,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: muted)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
