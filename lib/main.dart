import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'nav/bottom_nav.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFF3E4095), // Główny kolor aplikacji
  hintColor: const Color(0xFF16275A), // Kolor akcentu
  secondaryHeaderColor: const Color(0xFF009688), // Kolor tła AppBar
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF5F5F5)),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Kolor tła Scaffold
  shadowColor: Colors.grey, // Kolor cienia
  useMaterial3: true,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teleporting',
      theme: appTheme,
      home: const BottomNav(),
    );
  }
}
