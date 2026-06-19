import 'package:clinixpro_patient/app/utility/model/sample_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
import '../utility/auth_service.dart';

class ProfileController extends GetxController {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  final patient = Map<String, String>.from(PatientData.patient).obs;

  @override
  void onInit() {
    super.onInit();
    nameCtrl.text = patient['name'] ?? '';
    emailCtrl.text = patient['email'] ?? '';
    addressCtrl.text = patient['address'] ?? '';
  }

  void saveProfile() {
    patient['name'] = nameCtrl.text;
    patient['email'] = emailCtrl.text;
    patient['address'] = addressCtrl.text;
    patient.refresh();
    Get.back();
  }

  void showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Coming soon!', style: TextStyle(fontFamily: 'HankenGrotesk')),
      backgroundColor: primary,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void confirmLogout(BuildContext context) {
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
              // Circular logout warning badge
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

              // Title formatted with KronaOne typography
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

              // Dialog description text
              const Text(
                'Are you sure you want to sign out of your account?',
                style: TStyle.bodyMuted,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Actions layout row
              Row(
                children: [
                  // Cancel button
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

                  // Solid Sign Out confirmation button
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

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    super.onClose();
  }
}
