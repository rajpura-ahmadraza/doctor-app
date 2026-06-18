import 'package:get/get.dart';
import '../utility/model/sample_data.dart';

class ShellController extends GetxController {
  final index = 0.obs;

  int get unreadCount => PatientData.notifications.where((n) => n['read'] == false).length;

  void changeIndex(int i) {
    index.value = i;
  }
}
