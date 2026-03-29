import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/glass_ui.dart';
import '../../controllers/admin_dashboard_controller.dart';
import '../components/admin_components.dart';

class TrainerApplicationsTab extends GetView<AdminDashboardController> {
  const TrainerApplicationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: AdminActionButton(
            label: 'Refresh Applications',
            icon: Icons.refresh_rounded,
            onPressed: () => controller.loadTrainerApplications(),
            width: double.infinity,
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.loadingApplications.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: kNeon),
                    const SizedBox(height: 16),
                    Text(
                      'Loading applications...',
                      style: GoogleFonts.dmSans(fontSize: 13, color: kMuted),
                    ),
                  ],
                ),
              );
            }

            final pending =
                controller.trainerApplications
                    .where((app) => app['status'] == 'pending')
                    .toList();

            if (pending.isEmpty) {
              return EmptyStateWidget(
                title: 'No Pending Applications',
                message: 'All trainer applications have been reviewed',
                icon: Icons.done_all_rounded,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: pending.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder:
                  (context, index) =>
                      _buildApplicationCard(context, pending[index]),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildApplicationCard(BuildContext context, Map<String, dynamic> app) {
    final appId = app['id'] as String? ?? '';
    final userId = app['userId'] as String? ?? '';
    final name = app['fullName'] as String? ?? 'Unknown';
    final email = app['email'] as String? ?? 'N/A';
    final specialty = app['specialty'] as String? ?? 'Not specified';
    final experience = app['yearsOfExperience'] as String? ?? '0';
    final status = app['status'] as String? ?? 'pending';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: kLilac.withOpacity(0.2),
                child: Icon(Icons.person_3_rounded, color: kLilac, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      email,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: kMuted,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(status),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withOpacity(0.08)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildInfoField('Specialty', specialty)),
              Expanded(
                child: _buildInfoField('Experience', '$experience years'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (app['certifications'] != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Certifications:',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  (app['certifications'] as String? ?? 'None')
                      .split(',')
                      .join('\n'),
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: kMuted,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => AdminActionButton(
                    label: 'Reject',
                    icon: Icons.close_rounded,
                    isDestructive: true,
                    isLoading: controller.actionLoading.value,
                    onPressed:
                        appId.isNotEmpty
                            ? () => _showRejectDialog(context, appId)
                            : null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(
                  () => AdminActionButton(
                    label: 'Approve',
                    icon: Icons.check_rounded,
                    isLoading: controller.actionLoading.value,
                    onPressed:
                        appId.isNotEmpty && userId.isNotEmpty
                            ? () => controller.approveTrainerApplication(
                              appId,
                              userId,
                            )
                            : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: kMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _showRejectDialog(BuildContext context, String appId) {
    final notesController = TextEditingController();

    Get.defaultDialog(
      title: 'Reject Application',
      titleStyle: GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      backgroundColor: const Color(0xFF1A0330),
      radius: 16,
      content: Column(
        children: [
          Text(
            'Provide feedback for the applicant.',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: kMuted,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: notesController,
            maxLines: 4,
            style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Rejection reason...',
              hintStyle: GoogleFonts.dmSans(color: kMuted),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
            ),
          ),
        ],
      ),
      actions: [
        AdminActionButton(
          label: 'Cancel',
          isOutlined: true,
          onPressed: Get.back,
        ),
        const SizedBox(width: 8),
        Obx(
          () => AdminActionButton(
            label: 'Reject',
            isDestructive: true,
            isLoading: controller.actionLoading.value,
            onPressed: () {
              controller.rejectTrainerApplication(
                appId,
                notesController.text.isEmpty
                    ? 'No feedback provided'
                    : notesController.text,
              );
              Get.back();
            },
          ),
        ),
      ],
    );
  }
}
