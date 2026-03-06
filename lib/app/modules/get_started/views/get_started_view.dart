import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/get_started_controller.dart';

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

class GetStartedView extends GetView<GetStartedController> {
  const GetStartedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ink,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top section with illustration
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: sky.withOpacity(0.15),
                      border: Border.all(color: sky, width: 2),
                    ),
                    child: const Icon(CupertinoIcons.person_badge_plus, size: 50, color: sky),
                  ),
                  const SizedBox(height: 30),
                  const Text("Let's Get Started", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),
                  Text('Tell us about yourself', style: TextStyle(fontSize: 16, color: muted)),
                ],
              ),
            ),

            // Middle section with features
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  _buildFeatureItem(icon: CupertinoIcons.person, title: 'Personal Info', description: 'Share your basic details', color: neon),
                  const SizedBox(height: 16),
                  _buildFeatureItem(icon: CupertinoIcons.sportscourt, title: 'Fitness Goals', description: 'Define your workout objectives', color: coral),
                  const SizedBox(height: 16),
                  _buildFeatureItem(icon: CupertinoIcons.graph_square, title: 'Track Progress', description: 'Monitor your improvements', color: lilac),
                ],
              ),
            ),

            // Bottom section with button
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0, left: 30, right: 30),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => controller.startProfile(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: neon,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ink)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String title, required String description, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: stroke),
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
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 14, color: muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
