import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:gym_trainer/app/modules/favorite/views/favorite_view.dart';
import 'package:gym_trainer/app/modules/profile/views/profile_screen.dart';
import 'package:gym_trainer/app/modules/messaging/views/messaging_screen.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  // ─── Design Tokens ────────────────────────────────────────────────────────
  static const Color ink = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF111118);
  static const Color card = Color(0xFF17171F);
  static const Color raised = Color(0xFF1E1E28);
  static const Color stroke = Color(0xFF2A2A36);
  static const Color neon = Color(0xFFCBFF47);          // electric lime
  static const Color coral = Color(0xFFFF5C5C);
  static const Color sky = Color(0xFF5CE8FF);
  static const Color lilac = Color(0xFFA78BFA);
  static const Color muted = Color(0xFF6B6B7E);

  @override
  Widget build(BuildContext context) {
    final iconList = [
      CupertinoIcons.bolt,
      CupertinoIcons.heart_fill,
      CupertinoIcons.chat_bubble_fill,
      CupertinoIcons.person_fill,
    ];

    final pages = [
      _buildHomeTab(),
      const FavouriteView(),
      const MessagingScreen(),
      const ProfileScreen(),
    ];

    return Obx(
      () => Scaffold(
        backgroundColor: ink,
        extendBody: true,
        body: pages[controller.currentIndex.value],
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          backgroundColor: surface,
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isActive ? neon : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      iconList[index],
                      size: 22,
                      color: isActive ? ink : muted,
                    ),
                  ),
                ],
              ),
            );
          },
          activeIndex: controller.currentIndex.value,
          gapLocation: GapLocation.none,
          notchSmoothness: NotchSmoothness.softEdge,
          leftCornerRadius: 28,
          rightCornerRadius: 28,
          height: 72,
          splashColor: neon.withOpacity(0.12),
          onTap: controller.changeTab,
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSliverHeader(),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 28),
              _buildGreeting(),
              const SizedBox(height: 24),
              _buildSearchBar(),
              const SizedBox(height: 32),
              _buildStatsRow(),
              const SizedBox(height: 32),
              _buildCategoryTabs(),
              const SizedBox(height: 32),
              _buildUpcomingSessionsSection(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLabel('Top Trainers'),
                  const SizedBox(height: 16),
                  _buildTrainersList(),
                  const SizedBox(height: 24),
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  _buildSpecialOfferCard(),
                  const SizedBox(height: 100),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }

  // ─── Sliver App Bar ───────────────────────────────────────────────────────
  Widget _buildSliverHeader() {
    return SliverAppBar(
      backgroundColor: ink,
      expandedHeight: 0,
      floating: true,
      pinned: false,
      toolbarHeight: 72,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          bottom: false,
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              // Avatar
              _buildAvatar(),
              const Spacer(),
              _buildIconBtn(
                CupertinoIcons.bell,
                controller.unreadNotificationsCount,
                controller.navigateToNotifications,
              ),
              const SizedBox(width: 10),
              _buildIconBtn(
                CupertinoIcons.chat_bubble,
                controller.unreadMessagesCount,
                controller.navigateToMessages,
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: neon, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/user_avatar.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: raised,
            child: const Center(
              child: Text('M',
                  style: TextStyle(
                      color: neon, fontSize: 18, fontWeight: FontWeight.w800)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconBtn(IconData icon, RxInt badge, VoidCallback onTap) {
    return Obx(() {
      final count = badge.value;
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: raised,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, color: Colors.white70, size: 22),
              if (count > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: coral,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        count > 9 ? '9+' : '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  // ─── Greeting ─────────────────────────────────────────────────────────────
  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Hey, Mostafa ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const TextSpan(text: '👋', style: TextStyle(fontSize: 26)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Ready to crush it today?',
          style: TextStyle(color: muted, fontSize: 15, letterSpacing: 0.2),
        ),
      ],
    );
  }

  // ─── Search Bar ───────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stroke),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(CupertinoIcons.search, color: muted, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 15),
              cursorColor: neon,
              decoration: InputDecoration(
                hintText: 'Search trainers, workouts...',
                hintStyle: TextStyle(color: muted, fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              onSubmitted: (value) {
                // Handle search
              },
            ),
          ),
          const SizedBox(width: 8),
          // Filter button
          GestureDetector(
            onTap: () {
              // Open filter
            },
            child: Container(
              width: 44,
              height: 44,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: neon,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: neon.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(CupertinoIcons.slider_horizontal_3, color: ink, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Stats Row ────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatChip(CupertinoIcons.flame, '12', 'Streak', coral),
        const SizedBox(width: 12),
        _buildStatChip(CupertinoIcons.sportscourt, '48', 'Sessions', sky),
        const SizedBox(width: 12),
        _buildStatChip(CupertinoIcons.rosette, '5', 'Goals', neon),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label, Color accent) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: stroke),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accent, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: muted, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // ─── Category Tabs ────────────────────────────────────────────────────────
  Widget _buildCategoryTabs() {
    final categories = [
      {'icon': CupertinoIcons.sportscourt, 'label': 'Strength'},
      {'icon': CupertinoIcons.person_2, 'label': 'Yoga'},
      {'icon': CupertinoIcons.bolt, 'label': 'Cardio'},
      {'icon': CupertinoIcons.hand_raised, 'label': 'Boxing'},
      {'icon': CupertinoIcons.drop, 'label': 'Swim'},
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.selectedCategoryIndex.value == index;
            return GestureDetector(
              onTap: () => controller.selectCategory(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                decoration: BoxDecoration(
                  color: isSelected ? neon : card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? neon : stroke,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      categories[index]['icon'] as IconData,
                      color: isSelected ? ink : muted,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      categories[index]['label'] as String,
                      style: TextStyle(
                        color: isSelected ? ink : Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  // ─── Upcoming Sessions ────────────────────────────────────────────────────
  Widget _buildUpcomingSessionsSection() {
    return Obx(() {
      if (controller.upcomingBookings.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Upcoming Sessions'),
          const SizedBox(height: 16),
          ...controller.upcomingBookings.take(2).map(
                (booking) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildSessionCard(booking),
                ),
              ),
          const SizedBox(height: 28),
        ],
      );
    });
  }

  Widget _buildSessionCard(Map<String, dynamic> booking) {
    final isConfirmed = booking['status'] == 'confirmed';

    return GestureDetector(
      onTap: () => controller.navigateToBookingDetails(booking['id']),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isConfirmed ? neon.withOpacity(0.08) : card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isConfirmed ? neon.withOpacity(0.4) : stroke,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isConfirmed ? neon.withOpacity(0.15) : raised,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                CupertinoIcons.sportscourt,
                color: isConfirmed ? neon : muted,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking['sessionType'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'with ${booking['trainerName']}',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isConfirmed ? neon : raised,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    booking['date'] ?? '',
                    style: TextStyle(
                      color: isConfirmed ? ink : Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  booking['time'] ?? '',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Section Label ────────────────────────────────────────────────────────
  Widget _buildLabel(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        Text(
          'See all',
          style: TextStyle(
            color: neon,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ─── Trainers List ────────────────────────────────────────────────────────
  Widget _buildTrainersList() {
    return SizedBox(
      height: 200,
      child: Obx(
        () => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: controller.featuredTrainers.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (_, i) => _buildTrainerCard(controller.featuredTrainers[i]),
        ),
      ),
    );
  }

  Widget _buildTrainerCard(Map<String, dynamic> trainer) {
    final isAvailable = trainer['isAvailable'] == true;

    return GestureDetector(
      onTap: () => controller.navigateToTrainerDetails(trainer['id']),
      child: Container(
        width: 148,
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: stroke),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image area
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Container(
                    height: 96,
                    width: double.infinity,
                    color: raised,
                    child: Image.network(
                      trainer['image'] ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(CupertinoIcons.person_fill,
                            color: muted, size: 36),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: isAvailable ? neon : raised,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: isAvailable ? ink : muted,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isAvailable ? 'Open' : 'Busy',
                          style: TextStyle(
                            color: isAvailable ? ink : muted,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trainer['name'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    trainer['specialty'] ?? '',
                    style: TextStyle(color: muted, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(CupertinoIcons.star_fill, color: neon, size: 13),
                          const SizedBox(width: 3),
                          Text(
                            '${trainer['rating']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$${trainer['pricePerHour']}/h',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Quick Actions ────────────────────────────────────────────────────────
  Widget _buildQuickActions() {
    final actions = [
      {'icon': CupertinoIcons.calendar, 'label': 'Book', 'color': neon},
      {'icon': CupertinoIcons.time, 'label': 'History', 'color': sky},
      {'icon': CupertinoIcons.creditcard, 'label': 'Payment', 'color': lilac},
      {'icon': CupertinoIcons.headphones, 'label': 'Support', 'color': coral},
    ];

    return Row(
      children: actions.map((action) {
        final accent = action['color'] as Color;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: action == actions.last ? 0 : 10,
            ),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: stroke),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        action['icon'] as IconData,
                        color: accent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      action['label'] as String,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── Special Offer Card ───────────────────────────────────────────────────
  Widget _buildSpecialOfferCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: neon,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ink.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '🔥 LIMITED TIME',
                    style: TextStyle(
                      color: ink,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '20% Off\nFirst Session',
                  style: TextStyle(
                    color: ink,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: ink,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Claim Now →',
                    style: TextStyle(
                      color: neon,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Opacity(
            opacity: 0.2,
            child: const Text(
              '20\n%',
              style: TextStyle(
                color: ink,
                fontSize: 56,
                fontWeight: FontWeight.w900,
                height: 0.9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}