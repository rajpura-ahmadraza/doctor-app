import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
import 'splash_controller.dart';

/// ── Splash Screen ───────────────────────────────────────────────────────────
/// Renders a beautiful introductory branding screen with logo, animated components,
/// and a progress loader.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject and instantiate the SplashController to trigger timer and routing
    Get.put(SplashController());

    return const AppScaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Centered Branding Contents
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo container with dynamic shadows
                  SplashLogoWidget(),
                  SizedBox(height: 24),

                  // Brand Title
                  Text(
                    'ClinixPro',
                    style: TextStyle(
                      fontFamily: 'KronaOne',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: dark,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 6),

                  // Brand Subtitle
                  Text(
                    'Patient Portal',
                    style: TextStyle(
                      fontFamily: 'HankenGrotesk',
                      fontSize: 14,
                      color: dark500,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 48),

                  // Elegant progress loader indicator
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      color: primary,
                      strokeWidth: 2.5,
                    ),
                  ),
                ],
              ),
            ),

            // Footer version credentials
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'Powered by ClinixPro',
                    style: TextStyle(
                      fontFamily: 'HankenGrotesk',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: dark500,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'v1.0.0',
                    style: TextStyle(
                      fontFamily: 'HankenGrotesk',
                      fontSize: 10,
                      color: dark500,
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
}

/// ── Splash Logo Widget ──────────────────────────────────────────────────────
/// A premium container rendering the branded 'C' logo with styled gradient shadows.
class SplashLogoWidget extends StatelessWidget {
  const SplashLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: .35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: const Center(
        child: Text(
          'C',
          style: TextStyle(
            color: light,
            fontSize: 48,
            fontWeight: FontWeight.w800,
            fontFamily: 'HankenGrotesk',
          ),
        ),
      ),
    );
  }
}
