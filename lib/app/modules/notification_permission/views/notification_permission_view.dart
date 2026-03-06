import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/notification_permission_controller.dart';

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

class NotificationPermissionView extends GetView<NotificationPermissionController> {
  const NotificationPermissionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ink,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => controller.goBack(),
        ),
        centerTitle: true,
        title: const Text('Notifications', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Stay Updated', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            Text('Enable notifications to get reminders about your workouts', style: TextStyle(fontSize: 14, color: muted)),
            const SizedBox(height: 40),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: sky.withOpacity(0.15),
                      border: Border.all(color: sky, width: 2),
                    ),
                    child: const Icon(CupertinoIcons.bell_circle, size: 50, color: sky),
                  ),
                  const SizedBox(height: 30),
                  Obx(() {
                    final enabled = controller.notificationEnabled.value;
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: enabled ? neon : stroke, width: 2),
                        borderRadius: BorderRadius.circular(14),
                        color: enabled ? neon.withOpacity(0.1) : card,
                      ),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.bell_fill, color: enabled ? neon : muted, size: 28),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Enable Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: enabled ? neon : Colors.white)),
                                const SizedBox(height: 4),
                                Text('Get reminders and updates', style: TextStyle(fontSize: 12, color: muted)),
                              ],
                            ),
                          ),
                          Switch(
                            value: enabled,
                            onChanged: controller.toggleNotification,
                            activeColor: neon,
                            activeTrackColor: neon.withOpacity(0.3),
                            inactiveThumbColor: muted,
                            inactiveTrackColor: stroke,
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  Text('You can change this anytime in settings', style: TextStyle(fontSize: 12, color: muted, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => controller.nextStep(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: neon,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ink)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
