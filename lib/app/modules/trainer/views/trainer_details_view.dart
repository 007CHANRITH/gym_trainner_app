import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/trainer_details_controller.dart';

// ─── Design Tokens ─────────────────────────────────────────────────────────
const Color ink = Color(0xFF0A0A0F);
const Color card = Color(0xFF17171F);
const Color raised = Color(0xFF1E1E28);
const Color stroke = Color(0xFF2A2A36);
const Color neon = Color(0xFFCBFF47);
const Color coral = Color(0xFFFF5C5C);
const Color sky = Color(0xFF5CE8FF);
const Color lilac = Color(0xFFA78BFA);
const Color muted = Color(0xFF6B6B7E);

class TrainerDetailsView extends GetView<TrainerDetailsController> {
  const TrainerDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    const String trainerName = 'Alex Johnson';
    const String specialty = 'Strength & Conditioning';
    const double rating = 4.8;
    const int reviewCount = 32;
    const String description =
        'Alex is a certified trainer with 10+ years of experience helping clients achieve their fitness goals. Passionate about strength, nutrition, and holistic health.';
    const int age = 29;
    const double height = 1.82;

    return Scaffold(
      backgroundColor: ink,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHero(context, trainerName, specialty, rating, reviewCount),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildStatsRow(age, height, rating, reviewCount),
                    const SizedBox(height: 24),
                    _buildAbout(description),
                    const SizedBox(height: 20),
                    _buildCertifications(),
                    const SizedBox(height: 20),
                    _buildScheduleSection(),
                    const SizedBox(height: 24),
                    _buildActions(context),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────
  Widget _buildHero(BuildContext context, String name, String specialty,
      double rating, int reviewCount) {
    return Stack(
      children: [
        // Background photo
        SizedBox(
          height: 320,
          width: double.infinity,
          child: Image.network(
            'https://randomuser.me/api/portraits/men/32.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: raised,
              child: const Center(
                child: Icon(CupertinoIcons.person_fill, color: muted, size: 80),
              ),
            ),
          ),
        ),
        // Gradient overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  ink.withOpacity(0.5),
                  ink,
                ],
                stops: const [0.3, 0.7, 1.0],
              ),
            ),
          ),
        ),
        // Back button
        Positioned(
          top: 12,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ink.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: stroke),
              ),
              child: const Icon(CupertinoIcons.back,
                  color: Colors.white, size: 16),
            ),
          ),
        ),
        // Favourite button
        Positioned(
          top: 12,
          right: 16,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ink.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: stroke),
              ),
              child: const Icon(CupertinoIcons.heart,
                  color: Colors.white, size: 18),
            ),
          ),
        ),
        // Name block at bottom
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: neon,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Text(
                        'Available',
                        style: TextStyle(
                          color: ink,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialty,
                      style: TextStyle(color: Colors.white.withOpacity(0.7),
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              // Rating pill
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: stroke),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.star_fill, color: neon, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('($reviewCount)',
                        style: TextStyle(color: muted, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Stats row ──────────────────────────────────────────────────────────────
  Widget _buildStatsRow(int age, double height, double rating, int reviews) {
    return Row(
      children: [
        _statChip(CupertinoIcons.gift, '$age yrs', 'Age', coral),
        const SizedBox(width: 12),
        _statChip(CupertinoIcons.resize_v, '${height.toStringAsFixed(2)}m',
            'Height', sky),
        const SizedBox(width: 12),
        _statChip(CupertinoIcons.person_3, '${reviews}+', 'Clients', lilac),
      ],
    );
  }

  Widget _statChip(
      IconData icon, String value, String label, Color accent) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: stroke),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accent, size: 18),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: muted, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // ── About ─────────────────────────────────────────────────────────────────
  Widget _buildAbout(String description) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('About',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            )),
        const SizedBox(height: 12),
        Text(
          description,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  // ── Certifications ────────────────────────────────────────────────────────
  Widget _buildCertifications() {
    final certs = [
      {'icon': CupertinoIcons.checkmark_seal, 'label': 'Certified Personal Trainer (CPT)', 'color': neon},
      {'icon': CupertinoIcons.timer, 'label': '10+ years experience', 'color': sky},
      {'icon': CupertinoIcons.cart, 'label': 'Nutrition Specialist', 'color': coral},
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Certifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            )),
        const SizedBox(height: 12),
        ...certs.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: stroke),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: (c['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(c['icon'] as IconData,
                          color: c['color'] as Color, size: 17),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      c['label'] as String,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  // ── Schedule ──────────────────────────────────────────────────────────────
  Widget _buildScheduleSection() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final available = [true, true, false, true, true, false, true];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Schedule',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                )),
            Text('This week',
                style: TextStyle(color: muted, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(days.length, (i) {
            final isAvailable = available[i];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(days[i],
                    style: TextStyle(
                      color: muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(height: 6),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isAvailable ? neon.withOpacity(0.1) : raised,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isAvailable
                          ? neon.withOpacity(0.4)
                          : stroke,
                    ),
                  ),
                  child: Icon(
                    isAvailable
                        ? CupertinoIcons.checkmark
                        : CupertinoIcons.xmark,
                    color: isAvailable ? neon : muted,
                    size: 16,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  // ── Actions ───────────────────────────────────────────────────────────────
  Widget _buildActions(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Book button
        GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: neon,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Book a Session',
                style: TextStyle(
                  color: ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Message button
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: stroke),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.chat_bubble,
                          color: Colors.white70, size: 17),
                      const SizedBox(width: 8),
                      const Text('Message',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Review button
            Expanded(
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Write Review coming soon!')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: stroke),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.star,
                          color: Colors.white70, size: 17),
                      const SizedBox(width: 8),
                      const Text('Review',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}