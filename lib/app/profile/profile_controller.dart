import 'package:clinixpro_patient/app/utility/model/sample_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
import '../login/login_screen.dart';

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
      content:
          Text('Coming soon!', style: TextStyle(fontFamily: 'HankenGrotesk')),
      backgroundColor: primary,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign out?', style: TStyle.h3),
        content: Text('Are you sure you want to sign out of your account?',
            style: TStyle.bodyMuted),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel',
                  style:
                      TextStyle(color: primary, fontFamily: 'HankenGrotesk'))),
          TextButton(
            onPressed: () {
              Get.until((route) => route.isFirst);
              Get.offAll(() => const LoginScreen());
            },
            child: const Text('Sign out',
                style: TextStyle(color: errorCol, fontFamily: 'HankenGrotesk')),
          ),
        ],
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
