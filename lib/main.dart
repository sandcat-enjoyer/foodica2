import 'dart:convert';

import 'package:Foodica/pages/homescreen.dart';
import 'package:Foodica/pages/init_caloriegoals.dart';
import 'package:Foodica/providers/authentication_provider.dart';
import 'package:Foodica/utils/FlutterWidgetData.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:Foodica/pages/init_allergens.dart';
import 'package:Foodica/pages/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //WidgetKit.setItem("widgetData", jsonEncode(FlutterWidgetData("text")),
  //  "group.julesdebbaut.foodica");
  //WidgetKit.reloadAllTimelines();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => {runApp(const MyApp())});
}

bool isAllergensNotEmpty = false;
bool isDailyCaloriesNotEmpty = false;

_loadApp() {
  if (FirebaseAuth.instance.currentUser != null) {
    SharedPreferences.getInstance().then((prefs) {
      print("test" + prefs.getInt("daily").toString());
      if (prefs.getInt("daily") == null) {
        prefs.setInt("daily", 0);
      }
      isAllergensNotEmpty = prefs.getStringList("allergens") != null;
      isDailyCaloriesNotEmpty = prefs.getInt("daily") != null;
      print(isDailyCaloriesNotEmpty);
      if (prefs.getBool("firstTimeBoot") == true ||
          prefs.getBool("firstTimeBoot") == null) {
        FirebaseAuth.instance.signOut();
        prefs.setBool("firstTimeBoot", false);
      }
    });
    if (isAllergensNotEmpty = false) {
      return InitAllergens(
        user: FirebaseAuth.instance.currentUser!,
      );
    } else if (isDailyCaloriesNotEmpty = false) {
      return InitCalorieGoal(user: FirebaseAuth.instance.currentUser!);
    } else {
      return HomeScreenPage(user: FirebaseAuth.instance.currentUser!);
    }
  } else {
    return OnboardingScreen();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) =>
                  AuthenticationProvider(FirebaseAuth.instance)),
          StreamProvider(
              create: (BuildContext context) {
                return context.read<AuthenticationProvider>().authStateChanges;
              },
              initialData: null)
        ],
        child: MaterialApp(
          home: _loadApp(),
          theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.black,
              //fix this deprecation
              //accentColor: Colors.redAccent,
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.redAccent),
              appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black)),
          themeMode: ThemeMode.system,
          darkTheme: ThemeData(
              brightness: Brightness.dark,
              //accentColor: Colors.redAccent,
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white)),
          debugShowCheckedModeBanner: false,
        ));
  }
}
