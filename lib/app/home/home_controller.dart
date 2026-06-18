import 'package:get/get.dart';
import '../utility/model/sample_data.dart';

class HomeController extends GetxController {
  final patient = PatientData.patient.obs;
  final upcomingAppointment = PatientData.appointments.first.obs;
  final unreadNotificationsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    updateUnreadCount();
  }

  void updateUnreadCount() {
    unreadNotificationsCount.value = PatientData.notifications.where((n) => n['read'] == false).length;
  }
}
