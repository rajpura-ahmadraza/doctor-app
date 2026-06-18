import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ClinixPro Patient',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'HankenGrotesk',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8C8AF8)),
        scaffoldBackgroundColor: const Color(0xFFF6F2FF),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, elevation: 0),
        dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
      ),
      home: const LoginScreen(),
    );
  }
}
