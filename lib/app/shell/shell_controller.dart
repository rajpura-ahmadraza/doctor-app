import 'package:get/get.dart';
import '../utility/model/sample_data.dart';
import '../notifications/notifications_controller.dart';

/// ── Shell Controller ────────────────────────────────────────────────────────
/// Manages the active navigation tab index and reactive updates for the
/// global notification badge count.
class ShellController extends GetxController {
  // Reactive selected navigation tab index
  final index = 0.obs;

  /// Retrieves the reactive unread notification count.
  /// If NotificationsController is registered, reads its dynamic Rx notifications count.
  /// Otherwise, falls back to the initial static sample data.
  int get unreadCount {
    if (Get.isRegistered<NotificationsController>()) {
      return Get.find<NotificationsController>().unreadCount;
    }
    return PatientData.notifications.where((n) => n['read'] == false).length;
  }

  /// Updates the selected navigation tab index.
  void changeIndex(int i) {
    index.value = i;
  }
}
