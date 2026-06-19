import 'package:get/get.dart';

/// ── Authentication Service ──────────────────────────────────────────────────
/// A persistent GetxService that tracks the user's authentication state.
class AuthService extends GetxService {
  static AuthService get to => Get.find();

  // Reactive observable tracking login status
  final isLoggedIn = false.obs;

  /// Sets the authentication status to logged in.
  void login() {
    isLoggedIn.value = true;
  }

  /// Sets the authentication status to logged out.
  void logout() {
    isLoggedIn.value = false;
  }
}
