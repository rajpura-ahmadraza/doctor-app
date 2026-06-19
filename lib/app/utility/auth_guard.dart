import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_service.dart';

/// ── Authentication Guard Middleware ──────────────────────────────────────────
/// Intercepts navigation requests and redirects unauthenticated users to the login screen.
class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();

    // Redirect to login if user is not authenticated
    if (!authService.isLoggedIn.value) {
      return const RouteSettings(name: '/login');
    }
    
    // Allow navigation if user is authenticated
    return null;
  }
}
