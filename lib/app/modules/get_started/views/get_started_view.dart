import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/get_started_controller.dart';

class GetStartedView extends GetView<GetStartedController> {
  const GetStartedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade400,
              Colors.indigo.shade600,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top section with illustration
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.person_add,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Let\'s Get Started',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tell us about yourself',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Middle section with features
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  _buildFeatureItem(
                    icon: Icons.person,
                    title: 'Personal Info',
                    description: 'Share your basic details',
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureItem(
                    icon: Icons.fitness_center,
                    title: 'Fitness Goals',
                    description: 'Define your workout objectives',
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureItem(
                    icon: Icons.trending_up,
                    title: 'Track Progress',
                    description: 'Monitor your improvements',
                  ),
                ],
              ),
            ),

            // Bottom section with button
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0, left: 30, right: 30),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => controller.startProfile(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
