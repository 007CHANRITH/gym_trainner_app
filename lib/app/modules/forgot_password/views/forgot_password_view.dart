import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/glass_ui.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kInk,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Obx(
          () =>
              controller.currentStep.value == 0
                  ? IconButton(
                    icon: Icon(Icons.arrow_back, color: kSky),
                    onPressed: () => Get.back(),
                  )
                  : IconButton(
                    icon: Icon(Icons.arrow_back, color: kSky),
                    onPressed: controller.goBack,
                  ),
        ),
        title: Text(
          'Reset Password',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: trainerBackground()),
          SafeArea(
            child: Obx(
              () => Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (controller.currentStep.value == 0)
                            _buildChooseMethodStep(),
                          if (controller.currentStep.value == 1)
                            _buildEnterContactStep(),
                          if (controller.currentStep.value == 2)
                            _buildVerifyOtpStep(),
                          if (controller.currentStep.value == 3)
                            _buildResetPasswordStep(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step 0: Choose contact method ─────────────────────────────────────────
  Widget _buildChooseMethodStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'How would you like to reset your password?',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Choose your preferred recovery method',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: kMuted,
          ),
        ),
        const SizedBox(height: 48),
        // Email option
        _buildMethodCard(
          icon: Icons.email_rounded,
          title: 'Email',
          subtitle: 'Receive a password reset link via email',
          color: kSky,
          onTap: () => controller.selectContactMethod('email'),
        ),
        const SizedBox(height: 20),
        // Phone option
        _buildMethodCard(
          icon: Icons.phone_rounded,
          title: 'Phone',
          subtitle: 'Get an OTP code via SMS',
          color: kNeon,
          onTap: () => controller.selectContactMethod('phone'),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildMethodCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.08),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: color.withOpacity(0.15),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: kMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: kSky),
          ],
        ),
      ),
    );
  }

  // ─── Step 1: Enter contact method (email or phone) ──────────────────────────
  Widget _buildEnterContactStep() {
    final isEmail = controller.contactMethod.value == 'email';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          isEmail ? 'Enter your email address' : 'Enter your phone number',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isEmail
              ? 'We will send a password reset link'
              : 'We will send an OTP verification code',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: kMuted,
          ),
        ),
        const SizedBox(height: 48),
        _buildGlassTextField(
          controller:
              isEmail ? controller.emailController : controller.phoneController,
          hintText: isEmail ? 'your@email.com' : '+1234567890',
          icon: isEmail ? Icons.email_rounded : Icons.phone_rounded,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.phone,
        ),
        const SizedBox(height: 32),
        Obx(
          () => SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: kNeon,
                disabledBackgroundColor: kNeon.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  controller.isLoading.value
                      ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(kInk),
                        ),
                      )
                      : Text(
                        'Send Code',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kInk,
                        ),
                      ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ─── Step 2: Verify OTP ─────────────────────────────────────────────────────
  Widget _buildVerifyOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Enter verification code',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Check your email or phone for the code',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: kMuted,
          ),
        ),
        const SizedBox(height: 48),
        _buildGlassTextField(
          controller: controller.otpController,
          hintText: 'Enter 6-digit code',
          icon: Icons.pin_rounded,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        Obx(
          () => Center(
            child: Text(
              controller.otpResendCountdown.value > 0
                  ? 'Resend code in ${controller.otpResendCountdown.value}s'
                  : 'Didn\'t receive code?',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: controller.otpResendCountdown.value > 0 ? kMuted : kSky,
              ),
            ),
          ),
        ),
        if (controller.otpResendCountdown.value == 0)
          Align(
            child: TextButton(
              onPressed: controller.resendOtp,
              child: Text(
                'Resend Code',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kNeon,
                ),
              ),
            ),
          ),
        const SizedBox(height: 32),
        Obx(
          () => SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed:
                  controller.isLoading.value ? null : controller.verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: kNeon,
                disabledBackgroundColor: kNeon.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  controller.isLoading.value
                      ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(kInk),
                        ),
                      )
                      : Text(
                        'Verify Code',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kInk,
                        ),
                      ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ─── Step 3: Reset Password ────────────────────────────────────────────────
  Widget _buildResetPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Create new password',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Make it strong and unique',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: kMuted,
          ),
        ),
        const SizedBox(height: 40),
        Obx(
          () => _buildGlassTextField(
            controller: controller.newPasswordController,
            hintText: 'New Password',
            icon: Icons.lock_rounded,
            isPassword: true,
            showPassword: controller.showPassword.value,
            onShowPasswordChanged:
                (value) => controller.showPassword.value = value,
          ),
        ),
        const SizedBox(height: 18),
        Obx(
          () => _buildGlassTextField(
            controller: controller.confirmPasswordController,
            hintText: 'Confirm Password',
            icon: Icons.lock_rounded,
            isPassword: true,
            showPassword: controller.showConfirmPassword.value,
            onShowPasswordChanged:
                (value) => controller.showConfirmPassword.value = value,
          ),
        ),
        const SizedBox(height: 40),
        Obx(
          () => SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed:
                  controller.isLoading.value ? null : controller.resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: kNeon,
                disabledBackgroundColor: kNeon.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  controller.isLoading.value
                      ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(kInk),
                        ),
                      )
                      : Text(
                        'Reset Password',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kInk,
                        ),
                      ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ─── Reusable glass textfield ──────────────────────────────────────────────
  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool showPassword = false,
    Function(bool)? onShowPasswordChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword && !showPassword,
        style: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: kMuted,
          ),
          prefixIcon: Icon(icon, color: kSky),
          suffixIcon:
              isPassword
                  ? GestureDetector(
                    onTap: () => onShowPasswordChanged?.call(!showPassword),
                    child: Icon(
                      showPassword
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: kMuted,
                    ),
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
