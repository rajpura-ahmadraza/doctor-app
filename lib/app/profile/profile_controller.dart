import 'package:clinixpro_patient/app/utility/model/sample_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
import '../utility/dialogs.dart';

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
    AppDialogs.showLogoutDialog(context);
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    super.onClose();
  }
}
