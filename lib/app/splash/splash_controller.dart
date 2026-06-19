import 'package:get/get.dart';
import '../utility/auth_service.dart';

/// ── Splash Screen Controller ──────────────────────────────────────────────────
/// Manages the introductory splash delay and handles redirection to either the
/// login portal or the main shell dashboard based on the authentication status.
class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startNavigationDelay();
  }

  /// Starts the introductory delay and handles conditional routing.
  void _startNavigationDelay() async {
    // Show splash animation for 2.2 seconds
    await Future.delayed(const Duration(milliseconds: 2200));

    // Retrieve authentication service
    final authService = AuthService.to;

    if (authService.isLoggedIn.value) {
      Get.offAllNamed('/shell');
    } else {
      Get.offAllNamed('/login');
    }
  }
}
