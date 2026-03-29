import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/glass_ui.dart';
import '../../controllers/admin_dashboard_controller.dart';
import '../components/admin_components.dart';

class UsersTab extends GetView<AdminDashboardController> {
  const UsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ─── Toolbar ───────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search & Filter Row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        controller.searchUsersQuery.value = value;
                      },
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search by name or email...',
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: kMuted,
                        ),
                        prefixIcon: Icon(Icons.search_rounded, color: kNeon),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: kNeon.withOpacity(0.5)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(
                      () => DropdownButton<String>(
                        value: controller.filterUsersStatus.value,
                        items:
                            ['active', 'suspended', 'pending']
                                .map(
                                  (status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(
                                      status.toUpperCase(),
                                      style: GoogleFonts.dmSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.filterUsersStatus.value = value;
                          }
                        },
                        underline: const SizedBox(),
                        dropdownColor: const Color(0xFF1A0330),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AdminActionButton(
                label: 'Search Users',
                icon: Icons.search_rounded,
                onPressed: () => controller.searchUsers(),
                width: double.infinity,
              ),
            ],
          ),
        ),
        // ─── List ───────────────────────────────────────────────────────────
        Expanded(
          child: Obx(() {
            if (controller.loadingUsers.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: kNeon),
                    const SizedBox(height: 16),
                    Text(
                      'Loading users...',
                      style: GoogleFonts.dmSans(fontSize: 13, color: kMuted),
                    ),
                  ],
                ),
              );
            }

            if (controller.users.isEmpty) {
              return EmptyStateWidget(
                title: 'No Users Found',
                message: 'No users match your search criteria',
                icon: Icons.person_off_rounded,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: controller.users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final user = controller.users[index];
                return _buildUserCard(context, user);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildUserCard(BuildContext context, Map<String, dynamic> user) {
    final userId = user['id'] as String?;
    final name = user['name'] as String? ?? 'Unknown';
    final email = user['email'] as String? ?? 'N/A';
    final role = user['role'] as String? ?? 'user';
    final status = user['accountStatus'] as String? ?? 'active';

    // Handle Timestamp or String for createdAt
    String createdAt = 'N/A';
    final createdAtValue = user['createdAt'];
    if (createdAtValue != null) {
      if (createdAtValue is String) {
        createdAt = createdAtValue;
      } else {
        createdAt = createdAtValue.toString();
      }
    }

    return GestureDetector(
      onTap: () => _showUserProfile(context, user),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withValues(alpha: 0.08),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: kNeon.withValues(alpha: 0.2),
                  child: Icon(
                    role == 'trainer'
                        ? Icons.person_4_rounded
                        : Icons.person_rounded,
                    color: kNeon,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Role',
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: kMuted,
                        ),
                      ),
                      Text(
                        role.toUpperCase(),
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Joined',
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: kMuted,
                        ),
                      ),
                      Text(
                        createdAt,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (status == 'active')
                  Expanded(
                    child: AdminActionButton(
                      label: 'Suspend',
                      icon: Icons.block_rounded,
                      isDestructive: true,
                      onPressed:
                          () => _showSuspendDialog(context, userId, name),
                    ),
                  )
                else if (status == 'suspended')
                  Expanded(
                    child: Obx(
                      () => AdminActionButton(
                        label: 'Reactivate',
                        icon: Icons.check_rounded,
                        isLoading: controller.actionLoading.value,
                        onPressed:
                            userId != null
                                ? () => controller.reactivateUser(userId)
                                : null,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: AdminActionButton(
                    label: 'View Profile',
                    icon: Icons.person_rounded,
                    isOutlined: true,
                    onPressed: () => _showUserProfile(context, user),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSuspendDialog(BuildContext context, String? userId, String name) {
    final reasonController = TextEditingController();

    Get.defaultDialog(
      title: 'Suspend User',
      titleStyle: GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      backgroundColor: kInk,
      radius: 16,
      content: Column(
        children: [
          Text(
            'You are about to suspend $name\'s account.',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: kMuted,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: reasonController,
            maxLines: 3,
            style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Reason for suspension...',
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
            label: 'Suspend',
            isDestructive: true,
            isLoading: controller.actionLoading.value,
            onPressed:
                userId != null
                    ? () {
                      controller.suspendUser(
                        userId,
                        reasonController.text.isEmpty
                            ? 'No reason provided'
                            : reasonController.text,
                      );
                      Get.back();
                    }
                    : null,
          ),
        ),
      ],
    );
  }

  void _showUserProfile(BuildContext context, Map<String, dynamic> user) {
    final displayName = (user['name'] ?? 'User').toString();
    final email = (user['email'] ?? '').toString();

    Get.bottomSheet(
      SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: kInk,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            20 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'User Profile',
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                      tooltip: 'Close',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Text(
                        _initials(displayName.isNotEmpty ? displayName : email),
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            email.isEmpty ? '—' : email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: kMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildProfileField(
                          'Role',
                          user['role'],
                          icon: Icons.badge_outlined,
                        ),
                        _buildProfileField(
                          'Status',
                          user['accountStatus'],
                          icon: Icons.verified_user_outlined,
                        ),
                        _buildProfileField(
                          'Created',
                          user['createdAt'],
                          icon: Icons.calendar_today_rounded,
                        ),
                        if (user['accountStatus'] == 'suspended')
                          _buildProfileField(
                            'Suspend Reason',
                            user['suspendReason'],
                            icon: Icons.block_rounded,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildProfileField(String label, dynamic value, {IconData? icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Icon(icon ?? Icons.info_outline_rounded, color: kMuted, size: 18),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: kMuted,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 4,
            child: Text(
              _formatProfileValue(value),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatProfileValue(dynamic value) {
    if (value == null) return 'N/A';
    if (value is DateTime) return _formatDateTime(value.toLocal());

    final text = value.toString();
    final tsMatch = RegExp(
      r'Timestamp\(seconds=(\d+),\s*nanoseconds=(\d+)\)',
    ).firstMatch(text);
    if (tsMatch != null) {
      final seconds = int.tryParse(tsMatch.group(1) ?? '');
      if (seconds != null) {
        final dt =
            DateTime.fromMillisecondsSinceEpoch(seconds * 1000).toLocal();
        return _formatDateTime(dt);
      }
    }

    return text.isEmpty ? '—' : text;
  }

  String _formatDateTime(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  }

  String _initials(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 'U';
    final parts = trimmed.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts.take(2).map((p) => p.characters.first.toUpperCase());
    final result = letters.join();
    return result.isEmpty ? trimmed.characters.first.toUpperCase() : result;
  }
}
