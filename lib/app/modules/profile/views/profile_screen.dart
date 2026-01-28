import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121217),
      appBar: AppBar(
        backgroundColor: const Color(0xFF19141E),
        elevation: 0,
        title: const Text('My Profile', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqiGDWxu58BS_M9_hloRMYzZ_f7LMEs8a6qA&s',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Sophia Carter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'sophia.carter@example.com',
                  style: TextStyle(
                    color: Color(0xFFAA9EBC),
                    fontSize: 18,
                    fontFamily: 'Lexend',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Birthday: 01/01/1990',
                  style: TextStyle(
                    color: Color(0xFFAA9EBC),
                    fontSize: 16,
                    fontFamily: 'Lexend',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ProfileStatCard(label: 'Weight', value: '120 lbs'),
              _ProfileStatCard(label: 'Age', value: '34'),
              _ProfileStatCard(label: 'Height', value: "5'6''"),
            ],
          ),
          const SizedBox(height: 32),
          _ProfileMenu(),
        ],
      ),
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileStatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF352B3F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  final List<_MenuItem> items = const [
    _MenuItem(icon: Icons.person, label: 'Profile'),
    _MenuItem(icon: Icons.favorite, label: 'Favorite'),
    _MenuItem(icon: Icons.privacy_tip, label: 'Privacy Policy'),
    _MenuItem(icon: Icons.settings, label: 'Settings'),
    _MenuItem(icon: Icons.help_outline, label: 'Help'),
    _MenuItem(icon: Icons.logout, label: 'Logout'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map((item) => Card(
                color: const Color(0xFF19141E),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(item.icon, color: Colors.white),
                  title: Text(
                    item.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Lexend',
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                  onTap: () {},
                ),
              ))
          .toList(),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  const _MenuItem({required this.icon, required this.label});
}
