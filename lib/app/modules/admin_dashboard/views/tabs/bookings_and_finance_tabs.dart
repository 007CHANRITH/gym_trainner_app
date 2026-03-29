import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/glass_ui.dart';
import '../../controllers/admin_dashboard_controller.dart';
import '../components/admin_components.dart';

class BookingsTab extends GetView<AdminDashboardController> {
  const BookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AdminActionButton(
                label: 'Refresh Bookings',
                icon: Icons.refresh_rounded,
                onPressed: () => controller.loadBookings(),
                width: double.infinity,
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.loadingBookings.value) {
              return Center(child: CircularProgressIndicator(color: kNeon));
            }

            if (controller.bookings.isEmpty) {
              return EmptyStateWidget(
                title: 'No Bookings',
                message: 'No bookings to display',
                icon: Icons.calendar_today_rounded,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: controller.bookings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder:
                  (context, index) =>
                      _buildBookingCard(context, controller.bookings[index]),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBookingCard(BuildContext context, Map<String, dynamic> booking) {
    final bookingId = booking['id'] as String? ?? '';
    final trainerName = booking['trainerName'] as String? ?? 'Unknown';
    final status = booking['status'] as String? ?? 'pending';
    final scheduledAt = booking['scheduledAt'] as String? ?? 'N/A';
    final price = booking['price'] as num? ?? 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trainerName,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    scheduledAt,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: kMuted,
                    ),
                  ),
                ],
              ),
              StatusBadge(status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: kMuted,
                ),
              ),
              Text(
                '\$$price',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kNeon,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (status != 'completed' && status != 'cancelled')
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => AdminActionButton(
                      label: 'Cancel',
                      icon: Icons.close_rounded,
                      isDestructive: true,
                      isLoading: controller.actionLoading.value,
                      onPressed:
                          bookingId.isNotEmpty
                              ? () => _showCancelDialog(context, bookingId)
                              : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AdminActionButton(
                    label: 'Reassign',
                    icon: Icons.type_specimen_rounded,
                    isOutlined: true,
                    onPressed:
                        bookingId.isNotEmpty
                            ? () => _showReassignDialog(context, bookingId)
                            : null,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String bookingId) {
    final reasonController = TextEditingController();
    Get.defaultDialog(
      title: 'Cancel Booking',
      titleStyle: GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      backgroundColor: const Color(0xFF1A0330),
      radius: 16,
      content: TextField(
        controller: reasonController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Cancellation reason...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
        ),
      ),
      actions: [
        AdminActionButton(label: 'Keep', isOutlined: true, onPressed: Get.back),
        const SizedBox(width: 8),
        Obx(
          () => AdminActionButton(
            label: 'Cancel',
            isDestructive: true,
            isLoading: controller.actionLoading.value,
            onPressed: () {
              controller.cancelBooking(bookingId, reasonController.text);
              Get.back();
            },
          ),
        ),
      ],
    );
  }

  void _showReassignDialog(BuildContext context, String bookingId) {
    final trainerIdController = TextEditingController();
    Get.defaultDialog(
      title: 'Reassign Booking',
      backgroundColor: const Color(0xFF1A0330),
      radius: 16,
      content: TextField(
        controller: trainerIdController,
        decoration: InputDecoration(
          hintText: 'New Trainer ID...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
        ),
      ),
      actions: [
        AdminActionButton(
          label: 'Cancel',
          isOutlined: true,
          onPressed: Get.back,
        ),
        const SizedBox(width: 8),
        AdminActionButton(
          label: 'Reassign',
          onPressed: () {
            if (trainerIdController.text.isNotEmpty) {
              controller.reassignBooking(bookingId, trainerIdController.text);
              Get.back();
            }
          },
        ),
      ],
    );
  }
}

class FinanceTab extends GetView<AdminDashboardController> {
  const FinanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: kNeon,
            unselectedLabelColor: kMuted,
            indicatorColor: kNeon,
            tabs: const [Tab(text: 'Payouts'), Tab(text: 'Refunds')],
          ),
          Expanded(
            child: TabBarView(
              children: [_buildPayoutsTab(), _buildRefundsTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutsTab() {
    return Obx(() {
      if (controller.loadingFinance.value) {
        return Center(child: CircularProgressIndicator(color: kNeon));
      }

      if (controller.payouts.isEmpty) {
        return EmptyStateWidget(
          title: 'No Payouts',
          message: 'No payout requests',
          icon: Icons.account_balance_rounded,
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: controller.payouts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final payout = controller.payouts[index];
          final status = payout['status'] as String? ?? 'pending';
          final amount = payout['amount'] as num? ?? 0;

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.08),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$$amount',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kNeon,
                      ),
                    ),
                    StatusBadge(status),
                  ],
                ),
                const SizedBox(height: 10),
                if (status == 'pending')
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => AdminActionButton(
                            label: 'Approve',
                            isLoading: controller.actionLoading.value,
                            onPressed:
                                () => controller.approvePayout(payout['id']),
                          ),
                        ),
                      ),
                    ],
                  )
                else if (status == 'approved')
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => AdminActionButton(
                            label: 'Mark as Paid',
                            isLoading: controller.actionLoading.value,
                            onPressed:
                                () => controller.markPayoutAsPaid(payout['id']),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildRefundsTab() {
    return Obx(() {
      if (controller.loadingFinance.value) {
        return Center(child: CircularProgressIndicator(color: kNeon));
      }

      if (controller.refunds.isEmpty) {
        return EmptyStateWidget(
          title: 'No Refunds',
          message: 'No refund requests',
          icon: Icons.money_off_rounded,
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: controller.refunds.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final refund = controller.refunds[index];
          final status = refund['status'] as String? ?? 'pending';
          final amount = refund['amount'] as num? ?? 0;

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.08),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$$amount',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                    StatusBadge(status),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => AdminActionButton(
                          label: 'Approve',
                          isLoading: controller.actionLoading.value,
                          onPressed: () => controller.approveRefund(refund),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
