import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'theme.dart';
import 'auth_service.dart';

/// ── App Dialogs Utility ─────────────────────────────────────────────────────
/// Centralized container for all modal dialog prompts across the application.
class AppDialogs {
  
  /// 1. Exit application confirmation dialog
  static void showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: errorCol.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.power_settings_new_rounded,
                    color: errorCol,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Exit App?',
                style: TextStyle(
                  fontFamily: 'KronaOne',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: dark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to close and exit the ClinixPro application?',
                style: TStyle.bodyMuted,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: black200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'HankenGrotesk',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: dark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: errorCol,
                        foregroundColor: light,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Exit',
                        style: TextStyle(
                          fontFamily: 'HankenGrotesk',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: light,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 2. Logout confirmation dialog
  static void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: errorCol.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.logout_rounded,
                    color: errorCol,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sign out?',
                style: TextStyle(
                  fontFamily: 'KronaOne',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: dark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to sign out of your account?',
                style: TStyle.bodyMuted,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: black200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'HankenGrotesk',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: dark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        AuthService.to.logout();
                        Get.offAllNamed('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: errorCol,
                        foregroundColor: light,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Sign out',
                        style: TextStyle(
                          fontFamily: 'HankenGrotesk',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: light,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 3. Success dialog displayed after a password reset
  static void showPasswordResetSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: success,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Password Reset!',
              style: TStyle.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Your password has been successfully updated. You can now log in to your account.',
              style: TStyle.bodyMuted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Get.offAllNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: light,
                elevation: 0,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login_rounded, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Proceed to Login',
                    style: TextStyle(
                      fontFamily: 'HankenGrotesk',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 4. Successful booking confirmation dialog
  static void showBookingSuccessDialog(BuildContext context, DateTime selectedDate, String selectedSlot) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded, color: success, size: 40),
            ),
            const SizedBox(height: 16),
            const Text('Appointment Booked!', style: TStyle.h2, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Your appointment with Dr. Priya Sharma on ${DateFormat('dd MMM yyyy').format(selectedDate)} at $selectedSlot is confirmed.',
              style: TStyle.bodyMuted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: light,
                elevation: 0,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  fontFamily: 'HankenGrotesk',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 5. Cancel appointment alert dialog
  static void showCancelDialog(BuildContext context, String dateStr) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.event_busy_rounded,
                    color: orange,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cancel appointment?',
                style: TextStyle(
                  fontFamily: 'KronaOne',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: dark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to cancel your appointment with Dr. Priya Sharma on $dateStr?',
                style: TStyle.bodyMuted,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: errorCol),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel Appt',
                        style: TextStyle(
                          fontFamily: 'HankenGrotesk',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: errorCol,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: light,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Keep',
                        style: TextStyle(
                          fontFamily: 'HankenGrotesk',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: light,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
