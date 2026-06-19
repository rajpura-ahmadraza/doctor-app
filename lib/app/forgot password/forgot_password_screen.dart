import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
import '../utility/dialogs.dart';
import 'forgot_password_controller.dart';

// ── Forgot Password Screen ──────────────────────────────────────
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject ForgotPasswordController for managing recovery states
    final controller = Get.put(ForgotPasswordController());

    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Custom Header Widget containing logo, title, and back navigation button
              const ForgotPasswordHeaderWidget(),
              const SizedBox(height: 32),

              // Step progress timeline tracker
              Obx(() => ForgotPasswordStepIndicatorWidget(
                    currentStep: controller.step.value,
                  )),
              const SizedBox(height: 24),

              // Dynamic content area rendering inputs based on the current step
              ForgotPasswordContentWidget(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Forgot Password Header Widget ───────────────────────────────
class ForgotPasswordHeaderWidget extends StatelessWidget {
  const ForgotPasswordHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Styled Back Button on the top left
          Positioned(
            left: 0,
            top: 8,
            child: CircleAvatar(
              backgroundColor: light.withValues(alpha: 0.6),
              radius: 18,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: dark),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          // Centered branding & recovery information
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // Security key recovery icon container
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: primary.withValues(alpha: 0.3), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock_reset_rounded,
                    color: primary,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontFamily: 'KronaOne',
                  fontSize: 20,
                  color: dark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Recover your ClinixPro account access',
                style: TStyle.bodyMuted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Forgot Password Step Indicator ──────────────────────────────
class ForgotPasswordStepIndicatorWidget extends StatelessWidget {
  final int currentStep;

  const ForgotPasswordStepIndicatorWidget({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: List.generate(3, (index) {
          final isCompleted = index < currentStep;
          final isActive = index == currentStep;

          return Expanded(
            child: Row(
              children: [
                // Animated progress line
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 4,
                    decoration: BoxDecoration(
                      color: (isActive || isCompleted) ? primary : black200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (index < 2) const SizedBox(width: 8),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Forgot Password Content/Form Widget ─────────────────────────
class ForgotPasswordContentWidget extends StatelessWidget {
  final ForgotPasswordController controller;

  const ForgotPasswordContentWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Obx(() => _buildStepForm(context, controller.step.value)),
      ),
    );
  }

  // Helper function to build form content dynamically based on current step
  Widget _buildStepForm(BuildContext context, int step) {
    switch (step) {
      case 0:
        return _buildMobileInputStep(context);
      case 1:
        return _buildOtpInputStep(context);
      case 2:
        return _buildNewPasswordStep(context);
      default:
        return const SizedBox.shrink();
    }
  }

  // Step 0: Input mobile number
  Widget _buildMobileInputStep(BuildContext context) {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter Mobile Number', style: TStyle.h2),
        const SizedBox(height: 6),
        const Text(
          'We will send a 6-digit OTP code to verify your identity.',
          style: TStyle.bodyMuted,
        ),
        const SizedBox(height: 24),
        AppInput(
          label: 'Mobile number',
          hint: 'e.g. 03XXXXXXXXX',
          controller: controller.mobileCtrl,
          keyboardType: TextInputType.phone,
          prefix: const Icon(Icons.phone_outlined, size: 18, color: dark500),
        ),
        const SizedBox(height: 24),
        PrimaryBtn(
          label: 'Send OTP Code',
          loading: controller.loading.value,
          onTap: controller.nextStep,
          icon: Icons.send_rounded,
        ),
      ],
    );
  }

  // Step 1: Verification of 6-digit OTP
  Widget _buildOtpInputStep(BuildContext context) {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Verify OTP', style: TStyle.h2),
        const SizedBox(height: 6),
        Text(
          'Please enter the 6-digit OTP code sent to ${controller.mobileCtrl.text}',
          style: TStyle.bodyMuted,
        ),
        const SizedBox(height: 24),
        AppInput(
          label: 'Verification Code',
          hint: 'Enter 6-digit OTP',
          controller: controller.otpCtrl,
          keyboardType: TextInputType.number,
          prefix: const Icon(Icons.sms_outlined, size: 18, color: dark500),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Resend OTP trigger functionality (mock)
            },
            style: TextButton.styleFrom(
              foregroundColor: primary,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Resend OTP Code',
              style: TextStyle(
                fontFamily: 'HankenGrotesk',
                fontSize: 12,
                color: primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        PrimaryBtn(
          label: 'Verify OTP',
          loading: controller.loading.value,
          onTap: controller.nextStep,
          icon: Icons.verified_user_rounded,
        ),
      ],
    );
  }

  // Step 2: Set New Security Password
  Widget _buildNewPasswordStep(BuildContext context) {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose Password', style: TStyle.h2),
        const SizedBox(height: 6),
        const Text(
          'Create a strong, unique password to secure your account.',
          style: TStyle.bodyMuted,
        ),
        const SizedBox(height: 24),
        AppInput(
          label: 'New Password',
          hint: 'Enter strong password',
          controller: controller.newPassCtrl,
          obscure: controller.obscure1.value,
          prefix: const Icon(Icons.lock_outline_rounded, size: 18, color: dark500),
          suffix: IconButton(
            icon: Icon(
              controller.obscure1.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              size: 18,
              color: dark500,
            ),
            onPressed: controller.toggleObscure1,
          ),
        ),
        const SizedBox(height: 16),
        AppInput(
          label: 'Confirm Password',
          hint: 'Re-enter your password',
          controller: controller.confirmCtrl,
          obscure: controller.obscure2.value,
          prefix: const Icon(Icons.lock_outline_rounded, size: 18, color: dark500),
          suffix: IconButton(
            icon: Icon(
              controller.obscure2.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              size: 18,
              color: dark500,
            ),
            onPressed: controller.toggleObscure2,
          ),
        ),
        const SizedBox(height: 24),
        PrimaryBtn(
          label: 'Update & Login',
          loading: controller.loading.value,
          onTap: () {
            controller.resetPassword(context, () => _showSuccess(context));
          },
          icon: Icons.lock_open_rounded,
        ),
      ],
    );
  }

  // Alert dialog prompt on successful password reset
  void _showSuccess(BuildContext context) {
    AppDialogs.showPasswordResetSuccessDialog(context);
  }
}

// ── Change Password Screen ──────────────────────────────────────
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject ChangePasswordController for managing in-app password updates
    final controller = Get.put(ChangePasswordController());

    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Custom Header Widget for change password
              const ChangePasswordHeaderWidget(),
              const SizedBox(height: 32),

              // The edit/update password form
              ChangePasswordFormWidget(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Change Password Header Widget ───────────────────────────────
class ChangePasswordHeaderWidget extends StatelessWidget {
  const ChangePasswordHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Styled Back Button on the top left
          Positioned(
            left: 0,
            top: 8,
            child: CircleAvatar(
              backgroundColor: light.withValues(alpha: 0.6),
              radius: 18,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: dark),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          // Centered header description
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // Security Shield Icon indicating settings update
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: primary.withValues(alpha: 0.3), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.security_rounded,
                    color: primary,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Change Password',
                style: TextStyle(
                  fontFamily: 'KronaOne',
                  fontSize: 20,
                  color: dark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Update your current security credentials',
                style: TStyle.bodyMuted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Change Password Form Widget ─────────────────────────────────
class ChangePasswordFormWidget extends StatelessWidget {
  final ChangePasswordController controller;

  const ChangePasswordFormWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Update security password', style: TStyle.h2),
          const SizedBox(height: 6),
          const Text(
            'Enter your current password to set a new one.',
            style: TStyle.bodyMuted,
          ),
          const SizedBox(height: 24),

          // Current Password Field
          Obx(() => AppInput(
                label: 'Current Password',
                hint: 'Enter current password',
                controller: controller.currentCtrl,
                obscure: controller.ob1.value,
                prefix: const Icon(Icons.lock_outline_rounded, size: 18, color: dark500),
                suffix: IconButton(
                  icon: Icon(
                    controller.ob1.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 18,
                    color: dark500,
                  ),
                  onPressed: controller.toggleOb1,
                ),
              )),
          const SizedBox(height: 16),

          // New Password Field
          Obx(() => AppInput(
                label: 'New Password',
                hint: 'Enter new password',
                controller: controller.newCtrl,
                obscure: controller.ob2.value,
                prefix: const Icon(Icons.lock_outline_rounded, size: 18, color: dark500),
                suffix: IconButton(
                  icon: Icon(
                    controller.ob2.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 18,
                    color: dark500,
                  ),
                  onPressed: controller.toggleOb2,
                ),
              )),
          const SizedBox(height: 16),

          // Confirm New Password Field
          Obx(() => AppInput(
                label: 'Confirm New Password',
                hint: 'Re-enter new password',
                controller: controller.confirmCtrl,
                obscure: controller.ob3.value,
                prefix: const Icon(Icons.lock_outline_rounded, size: 18, color: dark500),
                suffix: IconButton(
                  icon: Icon(
                    controller.ob3.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 18,
                    color: dark500,
                  ),
                  onPressed: controller.toggleOb3,
                ),
              )),
          const SizedBox(height: 16),

          // Password rules
          const Text('Password requirements:', style: TStyle.label),
          const SizedBox(height: 6),
          _buildRule('At least 8 characters'),
          _buildRule('One uppercase letter'),
          _buildRule('One number or special character'),
          const SizedBox(height: 24),

          // Submit button
          Obx(() => PrimaryBtn(
                label: 'Update Password',
                loading: controller.loading.value,
                icon: Icons.save_rounded,
                onTap: () => controller.updatePassword(context),
              )),
        ],
      ),
    );
  }

  // Guidelines rule display widget
  Widget _buildRule(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 14, color: success),
          const SizedBox(width: 8),
          Text(text, style: TStyle.small),
        ],
      ),
    );
  }
}
