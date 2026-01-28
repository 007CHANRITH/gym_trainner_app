import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_permission_controller.dart';

class NotificationPermissionView
    extends GetView<NotificationPermissionController> {
  const NotificationPermissionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => controller.goBack(),
        ),
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stay Updated',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Enable notifications to get reminders about your workouts',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    size: 80,
                    color: Colors.indigo[400],
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: controller.notificationEnabled.value
                              ? Colors.indigo
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: controller.notificationEnabled.value
                            ? Colors.indigo.withOpacity(0.1)
                            : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications,
                            color: controller.notificationEnabled.value
                                ? Colors.indigo
                                : Colors.grey,
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Enable Notifications',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Get reminders and updates',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: controller.notificationEnabled.value,
                            onChanged: controller.toggleNotification,
                            activeColor: Colors.indigo,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'You can change this anytime in settings',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => controller.nextStep(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
