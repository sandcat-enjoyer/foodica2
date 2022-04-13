import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodica/data/data.dart';
import 'package:foodica/data/main.dart';
import 'package:flutter/material.dart';
import 'package:foodica/pages/homescreen.dart';
import 'package:foodica/pages/onboarding.dart';
import 'package:get/get.dart';
import "firebase_options.dart";
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

_loadApp() {
  if (FirebaseAuth.instance.currentUser != null) {
    return HomeScreenPage(user: FirebaseAuth.instance.currentUser!);
  } else {
    return OnboardingScreen();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _loadApp(),
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.black,
          floatingActionButtonTheme:
              const FloatingActionButtonThemeData(backgroundColor: Colors.red),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white, foregroundColor: Colors.black)),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.red, foregroundColor: Colors.white)),
      debugShowCheckedModeBanner: false,
    );
  }
}
