import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/trainer_details_controller.dart';

class TrainerDetailsView extends GetView<TrainerDetailsController> {
  const TrainerDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    const String trainerName = 'Alex Johnson';
    const String specialty = 'Strength & Conditioning';
    const double rating = 4.8;
    const int reviewCount = 32;
    const String description = 'Alex is a certified trainer with 10+ years of experience helping clients achieve their fitness goals. Passionate about strength, nutrition, and holistic health.';
    const int age = 29;
    const double height = 1.82; // meters
    final List<Map<String, String>> comments = [
      {
        'user': 'Sokha',
        'comment': 'Alex is super motivating and always brings out the best in me!'
      },
      {
        'user': 'Dara',
        'comment': 'Great trainer, very knowledgeable about nutrition and workouts.'
      },
      {
        'user': 'Sophea',
        'comment': 'I achieved my goals faster than I thought possible! Highly recommend.'
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121217),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1C26),
        title: const Text('Trainer Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF191121),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile picture
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: const Color(0xFF7A11EA),
                    backgroundImage: null, // Replace with NetworkImage or AssetImage for real photo
                    child: const Icon(Icons.person, size: 54, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    trainerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Specialty
                  Text(
                    specialty,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Rating and reviews
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(5, (i) => Icon(
                        i < rating.floor()
                          ? Icons.star
                          : (i < rating ? Icons.star_half : Icons.star_border),
                        color: const Color(0xFFFFD700),
                        size: 22,
                      )),
                      const SizedBox(width: 8),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Text('($reviewCount reviews)', style: const TextStyle(color: Colors.white54, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Age and Height
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF261933),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('Age: $age', style: const TextStyle(color: Colors.white70, fontSize: 15)),
                      ),
                      const SizedBox(width: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF261933),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('Height: ${height.toStringAsFixed(2)} m', style: const TextStyle(color: Colors.white70, fontSize: 15)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Description
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF221A2E),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      description,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 22),
                  // Message button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to chat screen with this trainer
                      },
                      icon: const Icon(Icons.message, color: Colors.white),
                      label: const Text('Message Trainer', style: TextStyle(fontSize: 17, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A11EA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Comments/Reviews Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Reviews', style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 14),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final c = comments[i];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF191121),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFF7A11EA),
                        child: Text(c['user']![0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c['user']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(c['comment']!, style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
