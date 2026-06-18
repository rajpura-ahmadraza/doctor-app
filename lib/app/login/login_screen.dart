import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
import 'forgot_password_screen.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const HeaderWidget(),
              const SizedBox(height: 40),
              ContentWidget(controller: controller),
              const SizedBox(height: 24),
              const Text('Powered by ClinixPro • v1.0.0', style: TStyle.small),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 48),
        // Logo
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

class ContentWidget extends StatelessWidget {
  final LoginController controller;

  const ContentWidget({super.key, required this.controller});

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

          AppInput(
            label: 'Mobile number',
            hint: 'Enter your mobile number',
            controller: controller.mobileCtrl,
            keyboardType: TextInputType.phone,
            prefix: const Icon(Icons.phone_outlined, size: 18, color: dark500),
          ),
          const SizedBox(height: 16),

          Obx(() => AppInput(
                label: 'Password',
                hint: 'Enter your password',
                controller: controller.passCtrl,
                obscure: controller.obscure.value,
                prefix: const Icon(Icons.lock_outline_rounded, size: 18, color: dark500),
                suffix: IconButton(
                  icon: Icon(controller.obscure.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 18, color: dark500),
                  onPressed: controller.toggleObscure,
                ),
              )),
          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Get.to(() => const ForgotPasswordScreen()),
              style: TextButton.styleFrom(
                  foregroundColor: primary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: const Text('Forgot password?',
                  style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 12, color: primary)),
            ),
          ),
          const SizedBox(height: 20),

          Obx(() => PrimaryBtn(
              label: 'Sign In',
              loading: controller.loading.value,
              onTap: () => controller.login(context),
              icon: Icons.login_rounded)),
          const SizedBox(height: 16),

          // Divider
          Row(children: [
            Expanded(child: Divider(color: dark.withValues(alpha: .1))),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('or', style: TStyle.bodyMuted)),
            Expanded(child: Divider(color: dark.withValues(alpha: .1))),
          ]),
          const SizedBox(height: 16),

          // Fingerprint button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => controller.loginWithBiometric(context),
              icon: const Icon(Icons.fingerprint, size: 22, color: primary),
              label: const Text('Sign in with Fingerprint',
                  style:
                      TextStyle(fontFamily: 'HankenGrotesk', fontSize: 14, fontWeight: FontWeight.w500, color: dark)),
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
