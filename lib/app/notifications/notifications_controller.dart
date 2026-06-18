import 'package:get/get.dart';
import '../utility/model/sample_data.dart';

class NotificationsController extends GetxController {
  final notifications = <Map<String, dynamic>>[].obs;
  final filter = 'All'.obs;
  final filters = const ['All', 'Follow-up', 'Vaccination', 'Medicine', 'Report', 'Appointment'];

  @override
  void onInit() {
    super.onInit();
    notifications.addAll(PatientData.notifications);
  }

  List<Map<String, dynamic>> get filteredNotifications {
    if (filter.value == 'All') return notifications;
    return notifications.where((n) => (n['type'] as String).toLowerCase() == filter.value.toLowerCase()).toList();
  }

  int get unreadCount => notifications.where((n) => n['read'] == false).length;

  void markAllRead() {
    for (final n in notifications) {
      n['read'] = true;
    }
    notifications.refresh();
  }

  void markRead(Map<String, dynamic> notification) {
    notification['read'] = true;
    notifications.refresh();
  }
}
