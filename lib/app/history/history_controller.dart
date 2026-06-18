import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';

class HistoryController extends GetxController {
  void showDownloadSnack(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Downloading $name...', style: const TextStyle(fontFamily: 'HankenGrotesk')),
      backgroundColor: success, behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }
}
