import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final currentStep =
      0.obs; // 0: Choose method, 1: Enter email/phone, 2: OTP, 3: Reset password
  final contactMethod = Rx<String?>(null); // 'email' or 'phone'
  final isLoading = false.obs;
  final isOtpSent = false.obs;
  final showPassword = false.obs;
  final showConfirmPassword = false.obs;
  final otpResendCountdown = 0.obs;

  final _auth = FirebaseAuth.instance;
  String? _verificationId;
  int? _tokenResend;

  @override
  void onClose() {
    emailController.dispose();
    phoneController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // ─── Step 1: User chooses email or phone ───────────────────────────────────
  void selectContactMethod(String method) {
    contactMethod.value = method;
    currentStep.value = 1;
  }

  // ─── Step 2: Send OTP ───────────────────────────────────────────────────────
  Future<void> sendOtp() async {
    if (contactMethod.value == 'email') {
      await _sendEmailOtp();
    } else {
      await _sendPhoneOtp();
    }
  }

  Future<void> _sendEmailOtp() async {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email address');
      return;
    }

    isLoading.value = true;
    try {
      // Check if user exists with this email
      final signinMethods = await _auth.fetchSignInMethodsForEmail(
        emailController.text,
      );

      if (signinMethods.isEmpty) {
        Get.snackbar('Error', 'No account found with this email');
        isLoading.value = false;
        return;
      }

      // Send password reset email
      await _auth.sendPasswordResetEmail(email: emailController.text);

      isOtpSent.value = true;
      currentStep.value = 2;
      _startOtpResendCountdown();

      Get.snackbar(
        'Email Sent',
        'Password reset link sent to ${emailController.text}',
        snackPosition: SnackPosition.TOP,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Failed to send reset email');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _sendPhoneOtp() async {
    if (phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number');
      return;
    }

    // Ensure phone number has country code
    String phoneNumber = phoneController.text;
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+${phoneNumber}';
    }

    isLoading.value = true;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieve SMS code
          await _auth.signInWithCredential(credential);
          isOtpSent.value = true;
          currentStep.value = 3;
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', e.message ?? 'Phone verification failed');
          isLoading.value = false;
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _tokenResend = resendToken;
          isOtpSent.value = true;
          currentStep.value = 2;
          _startOtpResendCountdown();
          Get.snackbar(
            'Code Sent',
            'OTP sent to $phoneNumber',
            snackPosition: SnackPosition.TOP,
          );
          isLoading.value = false;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(minutes: 2),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to send OTP');
      isLoading.value = false;
    }
  }

  // ─── Step 3: Verify OTP and proceed to password reset ───────────────────────
  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter the OTP');
      return;
    }

    if (contactMethod.value == 'email') {
      // For email, OTP verification is handled via the reset link
      // so we just move to password reset step
      currentStep.value = 3;
      return;
    }

    if (_verificationId == null) {
      Get.snackbar('Error', 'Verification ID not found');
      return;
    }

    isLoading.value = true;
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpController.text,
      );

      await _auth.signInWithCredential(credential);
      currentStep.value = 3;
      Get.snackbar('Success', 'OTP verified successfully');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Invalid OTP');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Step 4: Reset Password ────────────────────────────────────────────────
  Future<void> resetPassword() async {
    if (newPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter new password');
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    if (newPasswordController.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return;
    }

    isLoading.value = true;
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPasswordController.text);
        // Sign out to allow login with new password
        await _auth.signOut();

        Get.snackbar(
          'Success',
          'Password reset successfully. Please login with your new password.',
          snackPosition: SnackPosition.TOP,
        );

        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(Routes.LOGIN);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Failed to reset password');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Resend OTP ────────────────────────────────────────────────────────────
  Future<void> resendOtp() async {
    if (otpResendCountdown.value > 0) return;

    if (contactMethod.value == 'email') {
      await _sendEmailOtp();
    } else {
      // Resend phone OTP with token
      if (_tokenResend != null) {
        await _sendPhoneOtp();
      }
    }
  }

  // ─── Helper: Start resend countdown ────────────────────────────────────────
  void _startOtpResendCountdown() {
    otpResendCountdown.value = 60;
    Future.delayed(const Duration(seconds: 1), () {
      if (otpResendCountdown.value > 0) {
        otpResendCountdown.value--;
        _startOtpResendCountdown();
      }
    });
  }

  // ─── Go back to previous step ──────────────────────────────────────────────
  void goBack() {
    if (currentStep.value > 0) {
      currentStep.value--;
      isOtpSent.value = false;
      otpResendCountdown.value = 0;
    } else {
      Get.back();
    }
  }
}
