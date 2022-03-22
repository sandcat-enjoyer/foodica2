import 'dart:io';
import 'package:foodica/data/data.dart';
import 'package:foodica/data/main.dart';
import 'package:flutter/material.dart';
import 'package:foodica/pages/homescreen.dart';
import 'package:foodica/pages/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
