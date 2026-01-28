import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121217),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1C26),
        title: const Text('Messages', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final bool isUnread = index == 0;
          return Material(
            color: isUnread ? const Color(0xFF23203A) : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Get.toNamed('/message-screen');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage('https://randomuser.me/api/portraits/women/${index + 20}.jpg'),
                      radius: 28,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Trainer ${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                  fontSize: 17,
                                ),
                              ),
                              if (isUnread)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2F163),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text('NEW', style: TextStyle(color: Color(0xFF232222), fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Hey! Are you available for a session?',
                            style: TextStyle(
                              color: isUnread ? Colors.white : Colors.white.withOpacity(0.7),
                              fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('12:${index}0 PM', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
