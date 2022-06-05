import 'package:Foodica/pages/homescreen.dart';
import 'dart:ui';
import 'package:Foodica/pages/init_allergens.dart';
import 'package:Foodica/pages/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

bool isAllergensNotEmpty = false;

_loadApp() {
  if (FirebaseAuth.instance.currentUser != null) {
    SharedPreferences.getInstance().then((prefs) => {
          if (prefs.getStringList("allergens")!.isEmpty)
            {isAllergensNotEmpty = false}
          else
            {isAllergensNotEmpty = true}
        });
    if (isAllergensNotEmpty = true) {
      return HomeScreenPage(user: FirebaseAuth.instance.currentUser!);
    } else {
      return InitAllergens(user: FirebaseAuth.instance.currentUser!);
    }
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
          //fix this deprecation
          accentColor: Colors.red,
          floatingActionButtonTheme:
              const FloatingActionButtonThemeData(backgroundColor: Colors.red),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white, foregroundColor: Colors.black)),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Colors.red,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.red, foregroundColor: Colors.white)),
      debugShowCheckedModeBanner: false,
    );
  }
}
