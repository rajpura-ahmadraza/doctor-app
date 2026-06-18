import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
import 'login_screen.dart';
import 'forgot_password_controller.dart';

// ── Forgot Password ─────────────────────────────────────────────
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());

    return AppScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(children: [
                IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18)),
                const SizedBox(width: 4),
                Text('Reset Password', style: TStyle.h3),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Step indicator
                    Obx(() => _stepIndicator(controller.step.value)),
                    const SizedBox(height: 24),
                    GlassCard(child: Obx(() => _stepContent(context, controller))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepIndicator(int step) {
    return Row(
      children: List.generate(3, (i) => Expanded(child: Row(children: [
        Expanded(child: Container(height: 3, color: i <= step ? primary : black200,
          margin: EdgeInsets.only(left: i == 0 ? 0 : 4, right: i == 2 ? 0 : 4))),
        if (i < 2) const SizedBox(width: 4),
      ]))),
    );
  }

  Widget _stepContent(BuildContext context, ForgotPasswordController controller) {
    final step = controller.step.value;
    if (step == 0) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Enter your mobile number', style: TStyle.h2),
        const SizedBox(height: 6),
        Text('We will send a 6-digit OTP to verify your identity', style: TStyle.bodyMuted),
        const SizedBox(height: 20),
        AppInput(hint: 'Mobile number', controller: controller.mobileCtrl, keyboardType: TextInputType.phone,
          prefix: const Icon(Icons.phone_outlined, size: 18, color: dark500)),
        const SizedBox(height: 20),
        PrimaryBtn(label: 'Send OTP', loading: controller.loading.value, onTap: controller.nextStep),
      ]);
    }
    if (step == 1) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Enter OTP', style: TStyle.h2),
        const SizedBox(height: 6),
        Text('6-digit OTP sent to ${controller.mobileCtrl.text}', style: TStyle.bodyMuted),
        const SizedBox(height: 20),
        AppInput(hint: '6-digit OTP', controller: controller.otpCtrl, keyboardType: TextInputType.number,
          prefix: const Icon(Icons.sms_outlined, size: 18, color: dark500)),
        const SizedBox(height: 10),
        Align(alignment: Alignment.centerRight,
          child: TextButton(onPressed: () {}, style: TextButton.styleFrom(foregroundColor: primary, padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: const Text('Resend OTP', style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 12, color: primary)))),
        const SizedBox(height: 20),
        PrimaryBtn(label: 'Verify OTP', loading: controller.loading.value, onTap: controller.nextStep),
      ]);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Set new password', style: TStyle.h2),
      const SizedBox(height: 6),
      Text('Choose a strong password for your account', style: TStyle.bodyMuted),
      const SizedBox(height: 20),
      AppInput(label: 'New password', hint: 'Enter new password', controller: controller.newPassCtrl, obscure: controller.obscure1.value,
        prefix: const Icon(Icons.lock_outline_rounded, size: 18, color: dark500),
        suffix: IconButton(icon: Icon(controller.obscure1.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: dark500),
          onPressed: controller.toggleObscure1)),
      const SizedBox(height: 14),
      AppInput(label: 'Confirm password', hint: 'Re-enter new password', controller: controller.confirmCtrl, obscure: controller.obscure2.value,
        prefix: const Icon(Icons.lock_outline_rounded, size: 18, color: dark500),
        suffix: IconButton(icon: Icon(controller.obscure2.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: dark500),
          onPressed: controller.toggleObscure2)),
      const SizedBox(height: 20),
      PrimaryBtn(label: 'Reset Password', loading: controller.loading.value, onTap: () {
        controller.resetPassword(context, () => _showSuccess(context));
      }),
    ]);
  }

  void _showSuccess(BuildContext context) {
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 64, height: 64, decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
          child: const Icon(Icons.check_circle_rounded, color: success, size: 40)),
        const SizedBox(height: 16),
        const Text('Password Reset!', style: TStyle.h2, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text('Your password has been reset successfully. Please sign in with your new password.', style: TStyle.bodyMuted, textAlign: TextAlign.center),
        const SizedBox(height: 20),
        PrimaryBtn(label: 'Go to Login', onTap: () {
          Get.until((route) => route.isFirst);
          Get.offAll(() => const LoginScreen());
        }),
      ]),
    ));
  }
}

// ── Change Password ─────────────────────────────────────────────
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

    return AppScaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
            child: Row(children: [
              IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18)),
              const SizedBox(width: 4),
              Text('Change Password', style: TStyle.h3),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: GlassCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Update your password', style: TStyle.h2),
                  const SizedBox(height: 6),
                  Text('Enter your current password to set a new one', style: TStyle.bodyMuted),
                  const SizedBox(height: 24),

                  Obx(() => AppInput(label: 'Current password', hint: 'Enter current password', controller: controller.currentCtrl, obscure: controller.ob1.value,
                    prefix: const Icon(Icons.lock_outline_rounded, size: 18, color: dark500),
                    suffix: IconButton(icon: Icon(controller.ob1.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: dark500), onPressed: controller.toggleOb1))),
                  const SizedBox(height: 16),

                  Obx(() => AppInput(label: 'New password', hint: 'Enter new password', controller: controller.newCtrl, obscure: controller.ob2.value,
                    prefix: const Icon(Icons.lock_outline_rounded, size: 18, color: dark500),
                    suffix: IconButton(icon: Icon(controller.ob2.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: dark500), onPressed: controller.toggleOb2))),
                  const SizedBox(height: 16),

                  Obx(() => AppInput(label: 'Confirm new password', hint: 'Re-enter new password', controller: controller.confirmCtrl, obscure: controller.ob3.value,
                    prefix: const Icon(Icons.lock_outline_rounded, size: 18, color: dark500),
                    suffix: IconButton(icon: Icon(controller.ob3.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: dark500), onPressed: controller.toggleOb3))),
                  const SizedBox(height: 8),

                  // Password rules
                  _rule('At least 8 characters'),
                  _rule('One uppercase letter'),
                  _rule('One number or special character'),
                  const SizedBox(height: 24),

                  Obx(() => PrimaryBtn(label: 'Update Password', loading: controller.loading.value, icon: Icons.save_rounded, onTap: () => controller.updatePassword(context))),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _rule(String text) => Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Row(children: [
      const Icon(Icons.check_circle_outline_rounded, size: 14, color: dark500),
      const SizedBox(width: 6),
      Text(text, style: TStyle.small),
    ]),
  );
}
