import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/model/sample_data.dart';

class ChatController extends GetxController {
  final msgCtrl = TextEditingController();
  final scrollCtrl = ScrollController();
  final messages = <Map<String, dynamic>>[].obs;
  final sending = false.obs;

  @override
  void onInit() {
    super.onInit();
    messages.addAll(PatientData.messages);
  }

  void sendMessage() async {
    if (msgCtrl.text.trim().isEmpty) return;
    final text = msgCtrl.text.trim();
    msgCtrl.clear();
    
    messages.add({'isMe': true, 'text': text, 'time': 'Just now', 'sender': 'Me'});
    sending.value = true;
    scrollDown();
    
    await Future.delayed(const Duration(seconds: 2));
    
    sending.value = false;
    messages.add({
      'isMe': false, 
      'text': 'Thank you for your message. Our team will get back to you shortly during clinic hours (9 AM – 6 PM).', 
      'time': 'Just now', 
      'sender': 'Dr. Priya Sharma'
    });
    scrollDown();
  }

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollCtrl.hasClients) {
        scrollCtrl.animateTo(
          scrollCtrl.position.maxScrollExtent, 
          duration: const Duration(milliseconds: 300), 
          curve: Curves.easeOut
        );
      }
    });
  }

  @override
  void onClose() {
    msgCtrl.dispose();
    scrollCtrl.dispose();
    super.onClose();
  }
}
