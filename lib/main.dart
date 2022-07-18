import 'package:Foodica/pages/homescreen.dart';
import 'package:Foodica/pages/init_caloriegoals.dart';
import 'package:Foodica/providers/authentication_provider.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:Foodica/pages/init_allergens.dart';
import 'package:Foodica/pages/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => {runApp(const MyApp())});
}

bool isAllergensNotEmpty = false;
bool isDailyCaloriesNotEmpty = false;

_loadApp() {
  if (FirebaseAuth.instance.currentUser != null) {
    SharedPreferences.getInstance().then((prefs) {
      print(prefs.getInt("daily"));
      isAllergensNotEmpty = prefs.getStringList("allergens") != null;
      isDailyCaloriesNotEmpty = prefs.getInt("daily") != null;
      if (prefs.getBool("firstTimeBoot") == true) {
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
          builder: (context, child) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, child!),
            maxWidth: 1000,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(450, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(800, name: TABLET),
              const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ]
          ),
          home: _loadApp(),
          theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.black,
              //fix this deprecation
              accentColor: Colors.redAccent,
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.redAccent),
              appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black)),
          themeMode: ThemeMode.system,
          darkTheme: ThemeData(
              brightness: Brightness.dark,
              accentColor: Colors.redAccent,
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white)),
          debugShowCheckedModeBanner: false,
        ));
  }
}
