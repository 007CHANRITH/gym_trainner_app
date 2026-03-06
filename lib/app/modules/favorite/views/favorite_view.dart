import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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

class FavouriteView extends StatefulWidget {
  const FavouriteView({super.key});
  @override
  State<FavouriteView> createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {
  int _filterIndex = 0;
  final _filters = [
    {'label': 'All', 'icon': CupertinoIcons.square_grid_2x2},
    {'label': 'Available', 'icon': CupertinoIcons.checkmark_circle},
    {'label': 'Top Rated', 'icon': CupertinoIcons.star},
  ];

  static const List<Map<String, dynamic>> _trainers = [
    {'name': 'Alex Carter', 'specialty': 'Strength & HIIT', 'rating': 4.9, 'price': 65, 'sessions': 128, 'portrait': 10, 'available': true},
    {'name': 'Jordan Miles', 'specialty': 'Yoga & Mobility', 'rating': 4.8, 'price': 55, 'sessions': 94, 'portrait': 11, 'available': true},
    {'name': 'Sam Rivera', 'specialty': 'Cardio & Boxing', 'rating': 4.7, 'price': 70, 'sessions': 76, 'portrait': 12, 'available': false},
    {'name': 'Chris Lee', 'specialty': 'Powerlifting', 'rating': 4.6, 'price': 80, 'sessions': 52, 'portrait': 13, 'available': true},
    {'name': 'Priya Shah', 'specialty': 'Pilates & Core', 'rating': 4.9, 'price': 75, 'sessions': 143, 'portrait': 47, 'available': true},
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_filterIndex == 1) return _trainers.where((t) => t['available'] == true).toList();
    if (_filterIndex == 2) return _trainers.where((t) => (t['rating'] as double) >= 4.8).toList();
    return _trainers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ink,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildFilters(),
            const SizedBox(height: 20),
            Expanded(
              child: _filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) => _buildTrainerCard(_filtered[index], index),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [coral.withOpacity(0.2), coral.withOpacity(0.05)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: coral.withOpacity(0.3)),
            ),
            child: const Icon(CupertinoIcons.heart_fill, color: coral, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('My Favourites', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                const SizedBox(height: 2),
                Text('${_trainers.length} trainers saved', style: TextStyle(color: muted, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stroke),
      ),
      child: Row(
        children: List.generate(_filters.length, (i) {
          final active = _filterIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _filterIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: active ? neon : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_filters[i]['icon'] as IconData, color: active ? ink : muted, size: 16),
                    const SizedBox(width: 6),
                    Text(_filters[i]['label'] as String, style: TextStyle(color: active ? ink : Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: card, shape: BoxShape.circle, border: Border.all(color: stroke)),
            child: Icon(CupertinoIcons.heart, color: muted, size: 36),
          ),
          const SizedBox(height: 20),
          const Text('No trainers found', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Try changing the filter', style: TextStyle(color: muted, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildTrainerCard(Map<String, dynamic> t, int index) {
    final bool isAvailable = t['available'] as bool;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [card, card.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: stroke),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Avatar with status
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              gradient: isAvailable
                                  ? LinearGradient(colors: [neon, neon.withOpacity(0.5)])
                                  : LinearGradient(colors: [stroke, stroke.withOpacity(0.5)]),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: SizedBox(
                                width: 64, height: 64,
                                child: Image.network(
                                  'https://randomuser.me/api/portraits/men/${t['portrait']}.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(color: raised, child: const Icon(CupertinoIcons.person_fill, color: muted, size: 28)),
                                ),
                              ),
                            ),
                          ),
                          Positioned(bottom: 0, right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(color: card, shape: BoxShape.circle),
                              child: Container(
                                width: 12, height: 12,
                                decoration: BoxDecoration(color: isAvailable ? neon : muted, shape: BoxShape.circle),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(t['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: neon.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(CupertinoIcons.star_fill, color: neon, size: 14),
                                      const SizedBox(width: 3),
                                      Text('${t['rating']}', style: const TextStyle(color: neon, fontSize: 12, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(t['specialty'] as String, style: TextStyle(color: muted, fontSize: 13)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(CupertinoIcons.sportscourt, color: muted, size: 12),
                                const SizedBox(width: 4),
                                Text('${t['sessions']} sessions', style: TextStyle(color: muted.withOpacity(0.8), fontSize: 11)),
                                const SizedBox(width: 12),
                                Container(width: 1, height: 10, color: stroke),
                                const SizedBox(width: 12),
                                Text('\$${t['price']}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                                Text('/hr', style: TextStyle(color: muted, fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          icon: CupertinoIcons.chat_bubble,
                          label: 'Message',
                          filled: false,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: _actionButton(
                          icon: CupertinoIcons.calendar,
                          label: 'Book Session',
                          filled: true,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton({required IconData icon, required String label, required bool filled, required VoidCallback onTap}) {
    return Material(
      color: filled ? neon : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: filled ? null : Border.all(color: stroke),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: filled ? ink : muted, size: 16),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: filled ? ink : Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}