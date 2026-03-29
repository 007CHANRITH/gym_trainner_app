import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/glass_ui.dart';
import '../controllers/trainer_availability_controller.dart';

class TrainerAvailabilityView extends GetView<TrainerAvailabilityController> {
  const TrainerAvailabilityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kInk,
      extendBodyBehindAppBar: true,
      appBar: glassAppBar(title: 'Availability', onBack: () => Get.back()),
      body: Stack(
        children: [
          Positioned.fill(child: trainerBackground()),
          SafeArea(
            child: Column(
              children: [
                // Header with active days counter
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
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
                                'Set Your Schedule',
                                style: GoogleFonts.bebasNeue(
                                  fontSize: 24,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Choose when you\'re available',
                                style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  color: kMuted,
                                ),
                              ),
                            ],
                          ),
                          Obx(
                            () => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: kNeon.withValues(alpha: 0.2),
                                border: Border.all(
                                  color: kNeon.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Text(
                                '${controller.activeCount} Active',
                                style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: kNeon,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Scrollable days grid
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 8,
                    ),
                    child: Obx(
                      () => GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.25,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount: controller.availability.length,
                        itemBuilder: (context, index) {
                          final entry =
                              controller.availability.entries.toList()[index];
                          final day = entry.key;
                          final dayData = entry.value;
                          return _DayAvailabilityCard(
                            day: day,
                            isActive: dayData['active'],
                            startTime: dayData['startTime'],
                            endTime: dayData['endTime'],
                            onToggle: () => controller.toggleDay(day),
                            onStartTimeChanged:
                                (time) => controller.setStartTime(day, time),
                            onEndTimeChanged:
                                (time) => controller.setEndTime(day, time),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // Save button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: controller.saveAvailability,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kNeon,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Save Schedule',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: kInk,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Individual day card
class _DayAvailabilityCard extends StatefulWidget {
  final String day;
  final RxBool isActive;
  final String startTime;
  final String endTime;
  final VoidCallback onToggle;
  final Function(String) onStartTimeChanged;
  final Function(String) onEndTimeChanged;

  const _DayAvailabilityCard({
    required this.day,
    required this.isActive,
    required this.startTime,
    required this.endTime,
    required this.onToggle,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  });

  @override
  State<_DayAvailabilityCard> createState() => _DayAvailabilityCardState();
}

class _DayAvailabilityCardState extends State<_DayAvailabilityCard> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withValues(alpha: 0.08),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Day header with toggle
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 6, 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.day,
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Obx(
                            () => Text(
                              widget.isActive.value ? 'Available' : 'Off',
                              style: GoogleFonts.dmSans(
                                fontSize: 8,
                                color: widget.isActive.value ? kNeon : kMuted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => Transform.scale(
                        scale: 0.65,
                        child: Switch(
                          value: widget.isActive.value,
                          onChanged: (_) => widget.onToggle(),
                          activeThumbColor: kNeon,
                          inactiveTrackColor: kMuted.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Time pickers (collapsible)
              Obx(
                () => AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child:
                      widget.isActive.value
                          ? Padding(
                            padding: const EdgeInsets.fromLTRB(5, 1, 5, 4),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 0.5,
                                  color: Colors.white.withOpacity(0.1),
                                  margin: const EdgeInsets.only(bottom: 3),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: _CompactTimePicker(
                                        label: 'Start',
                                        time: widget.startTime,
                                        onTimeChanged:
                                            widget.onStartTimeChanged,
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: _CompactTimePicker(
                                        label: 'End',
                                        time: widget.endTime,
                                        onTimeChanged: widget.onEndTimeChanged,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Compact time picker
class _CompactTimePicker extends StatelessWidget {
  final String label;
  final String time;
  final Function(String) onTimeChanged;

  const _CompactTimePicker({
    required this.label,
    required this.time,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTimePicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white.withValues(alpha: 0.08),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 7,
                color: kMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              time,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _parseTime(time),
    );
    if (picked != null) {
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      onTimeChanged('$hour:$minute');
    }
  }

  TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
