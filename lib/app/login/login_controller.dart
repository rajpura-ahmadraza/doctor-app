import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import '../utility/theme.dart';
import '../utility/auth_service.dart';

class LoginController extends GetxController {
  final mobileCtrl = TextEditingController(text: '9876543210');
  final passCtrl = TextEditingController(text: 'patient123');

  final obscure = true.obs;
  final loading = false.obs;

  final auth = LocalAuthentication();

  void toggleObscure() {
    obscure.value = !obscure.value;
  }

  void login(BuildContext context) async {
    if (mobileCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      showSnack(context, 'Please enter mobile number and password',
          isError: true);
      return;
    }
    loading.value = true;
    await Future.delayed(const Duration(milliseconds: 1200));
    loading.value = false;

    AuthService.to.login();
    Get.offAllNamed('/shell');
  }

  void loginWithBiometric(BuildContext context) async {
    try {
      final canCheck = await auth.canCheckBiometrics;
      if (!canCheck) {
        if (context.mounted) {
          showSnack(
              context, 'Biometric authentication not available on this device',
              isError: true);
        }
        return;
      }
      final authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to access your health records',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
      if (authenticated) {
        AuthService.to.login();
        Get.offAllNamed('/shell');
      }
    } on PlatformException {
      if (context.mounted) {
        showSnack(
            context, 'Biometric authentication failed. Please use password.',
            isError: true);
      }
    }
  }

  void showSnack(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontFamily: 'HankenGrotesk')),
      backgroundColor: isError ? errorCol : success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  void onClose() {
    mobileCtrl.dispose();
    passCtrl.dispose();
    super.onClose();
  }
}
