import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({Key? key}) : super(key: key);

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
              Colors.blue.shade400,
              Colors.blue.shade600,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top section with logo/welcome text
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Column(
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'to Your Fitness Journey',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Middle section with welcome message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const Text(
                    'Get ready to transform your body and achieve your fitness goals with professional trainers.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
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
                  onPressed: () => controller.goToGetStarted(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
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
}
