import 'package:clinixpro_patient/app/forgot%20password/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
import 'login_controller.dart';

/// ── Login Screen ────────────────────────────────────────────────────────────
/// Renders the patient authentication landing portal. Lays out a logo/branding
/// header and the core login card with mobile/password fields.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject and instantiate the LoginController
    final controller = Get.put(LoginController());

    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Branding logo and Title header
              const LoginHeaderWidget(),
              const SizedBox(height: 40),

              // 2. Authentication inputs, biometric trigger, and password recovery triggers
              LoginContentWidget(controller: controller),
              const SizedBox(height: 24),

              // Footer version representation info
              const Text('Powered by ClinixPro • v1.0.0', style: TStyle.small),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// ── Login Header Widget ──────────────────────────────────────────────────────
/// A branding header widget containing the portal logo icon, app name, and screen subtitle.
class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 48),

        // Centered App logo badge with shadows
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: .3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: const Center(
            child: Text(
              'C',
              style: TextStyle(
                color: light,
                fontSize: 36,
                fontWeight: FontWeight.w800,
                fontFamily: 'HankenGrotesk',
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // App main name
        const Text(
          'ClinixPro',
          style: TextStyle(
            fontFamily: 'KronaOne',
            fontSize: 24,
            color: dark,
          ),
        ),
        const SizedBox(height: 4),
        const Text('Patient Portal', style: TStyle.bodyMuted),
      ],
    );
  }
}

/// ── Login Content Widget ─────────────────────────────────────────────────────
/// Form wrapper card housing text input controllers, biometric login triggers,
/// and password reset routing actions.
class LoginContentWidget extends StatelessWidget {
  final LoginController controller;

  const LoginContentWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Welcome back', style: TStyle.h2),
          const SizedBox(height: 4),
          const Text('Sign in to access your health records', style: TStyle.bodyMuted),
          const SizedBox(height: 24),

          // Mobile number entry field
          AppInput(
            label: 'Mobile number',
            hint: 'Enter your mobile number',
            controller: controller.mobileCtrl,
            keyboardType: TextInputType.phone,
            prefix: const Icon(Icons.phone_outlined, size: 18, color: dark500),
          ),
          const SizedBox(height: 16),

          // Password entry field (masked/unmasked dynamically)
          Obx(() => AppInput(
                label: 'Password',
                hint: 'Enter your password',
                controller: controller.passCtrl,
                obscure: controller.obscure.value,
                prefix: const Icon(Icons.lock_outline_rounded, size: 18, color: dark500),
                suffix: IconButton(
                  icon: Icon(
                    controller.obscure.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 18,
                    color: dark500,
                  ),
                  onPressed: controller.toggleObscure,
                ),
              )),
          const SizedBox(height: 10),

          // Forgot password trigger
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Get.to(() => const ForgotPasswordScreen()),
              style: TextButton.styleFrom(
                  foregroundColor: primary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: const Text(
                'Forgot password?',
                style: TextStyle(
                  fontFamily: 'HankenGrotesk',
                  fontSize: 12,
                  color: primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Primary Sign In action button
          Obx(() => PrimaryBtn(
                label: 'Sign In',
                loading: controller.loading.value,
                onTap: () => controller.login(context),
                icon: Icons.login_rounded,
              )),
          const SizedBox(height: 16),

          // Visual Divider
          Row(
            children: [
              Expanded(child: Divider(color: dark.withValues(alpha: .1))),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('or', style: TStyle.bodyMuted),
              ),
              Expanded(child: Divider(color: dark.withValues(alpha: .1))),
            ],
          ),
          const SizedBox(height: 16),

          // Secondary Biometric fingerprint verification trigger
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => controller.loginWithBiometric(context),
              icon: const Icon(Icons.fingerprint, size: 22, color: primary),
              label: const Text(
                'Sign in with Fingerprint',
                style: TextStyle(
                  fontFamily: 'HankenGrotesk',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: dark,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: black200),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                backgroundColor: light,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
