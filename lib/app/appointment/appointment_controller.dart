import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentController extends GetxController {
  final selectedDate = DateTime.now().add(const Duration(days: 1)).obs;
  final selectedSlot = RxnString();
  final selectedType = 'Follow-up'.obs;
  final selectedPayment = 'upi'.obs;
  final booking = false.obs;

  final types = ['Follow-up', 'New Consultation', 'Routine Check-up', 'Emergency'];

  void selectDate(DateTime date) {
    selectedDate.value = date;
    selectedSlot.value = null;
  }

  void selectSlot(String slot) {
    selectedSlot.value = slot;
  }

  void selectType(String type) {
    selectedType.value = type;
  }

  void selectPayment(String payment) {
    selectedPayment.value = payment;
  }

  void confirmBooking(BuildContext context, VoidCallback onSuccess) async {
    booking.value = true;
    await Future.delayed(const Duration(milliseconds: 1500));
    booking.value = false;
    onSuccess();
  }
}
