import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';

class ForgotPasswordController extends GetxController {
  final mobileCtrl = TextEditingController();
  final otpCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  
  final step = 0.obs;
  final loading = false.obs;
  final obscure1 = true.obs;
  final obscure2 = true.obs;

  void toggleObscure1() => obscure1.value = !obscure1.value;
  void toggleObscure2() => obscure2.value = !obscure2.value;

  void nextStep() async {
    loading.value = true;
    if (step.value == 0) {
      await Future.delayed(const Duration(milliseconds: 1000));
      step.value = 1;
    } else if (step.value == 1) {
      await Future.delayed(const Duration(milliseconds: 800));
      step.value = 2;
    }
    loading.value = false;
  }

  void resetPassword(BuildContext context, VoidCallback onSuccess) async {
    loading.value = true;
    await Future.delayed(const Duration(milliseconds: 1000));
    loading.value = false;
    onSuccess();
  }

  @override
  void onClose() {
    mobileCtrl.dispose();
    otpCtrl.dispose();
    newPassCtrl.dispose();
    confirmCtrl.dispose();
    super.onClose();
  }
}

class ChangePasswordController extends GetxController {
  final currentCtrl = TextEditingController();
  final newCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  
  final ob1 = true.obs;
  final ob2 = true.obs;
  final ob3 = true.obs;
  final loading = false.obs;

  void toggleOb1() => ob1.value = !ob1.value;
  void toggleOb2() => ob2.value = !ob2.value;
  void toggleOb3() => ob3.value = !ob3.value;

  void updatePassword(BuildContext context) async {
    loading.value = true;
    await Future.delayed(const Duration(milliseconds: 1200));
    loading.value = false;
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Password updated successfully!', style: TextStyle(fontFamily: 'HankenGrotesk')),
        backgroundColor: success, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
    Get.back();
  }

  @override
  void onClose() {
    currentCtrl.dispose();
    newCtrl.dispose();
    confirmCtrl.dispose();
    super.onClose();
  }
}
