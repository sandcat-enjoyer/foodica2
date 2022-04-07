import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:foodica/pages/calorie_detail.dart';
import 'package:foodica/pages/history.dart';
import 'package:foodica/pages/login.dart';
import 'package:foodica/pages/productdetail.dart';
import 'package:foodica/pages/settings.dart';
import 'package:foodica/pages/tips.dart';
import 'package:foodica/utils/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _HomeScreenPageState createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  late Future<int> _weeklyCalories;
  late Future<int> _calorieGoal;
  late User _user;

  //i genuinely forgot how to easily concatenate strings in dart
  //so for now i just append 2 numbers in a string and return the value of that
  String? weeklyDisplayValue;
  String displayName = "";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Widget? mainWidget;
  bool codeIsScanned = false;
  Colors? navBackColor;
  Color? bgColor;
  bool _isSigningOut = false;

  late int? _weeklyCaloriesInt = 0;
  late int? _calorieGoalInt = 0;

  @override
  void initState() {
    super.initState();
    _user = widget._user;
    _getWeeklyCalories();
    _calorieGoal = _prefs.then((SharedPreferences prefs) {
      _calorieGoalInt = prefs.getInt("goal") ?? 0;
      return _calorieGoal;
    });
    _reloadLocalStorage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getWeeklyCalories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _weeklyCaloriesInt = prefs.getInt("weekly");
  }

  void _getCalorieGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _calorieGoalInt = prefs.getInt("goal");
  }

  void _reloadLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
  }

  String _checkProfileName() {
    if (_user.displayName == null) {
      return "";
    } else {
      return _user.displayName!;
    }
  }

  String _checkPhotoURL() {
    if (_user.photoURL == null) {
      return "https://via.placeholder.com/300";
    } else {
      return _user.photoURL!;
    }
  }

  void navigateToHistory() {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => const HistoryPage()));
  }

  void navigateToSettings() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SettingsPage()));
  }

  void navigateToTips() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const TipsPage()));
  }

  Route _routeToLoginScreen() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(-1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  Widget? _buildHomeScreen() {
    if (mainWidget == null) {
      return SingleChildScrollView(
          child: Column(children: [
        Container(
          padding: const EdgeInsets.all(20.0),
          child: const Text("Welcome",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  fontSize: 40)),
        ),
        Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                    child: Wrap(
                  spacing: 20,
                  runSpacing: 20.0,
                  children: <Widget>[
                    SizedBox(
                      width: 350.0,
                      height: 200.0,
                      child: Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CalorieDetailPage())),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  const Icon(
                                    Icons.food_bank_outlined,
                                    size: 60,
                                  ),
                                  const Text(
                                    "Weekly Calories",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30.0),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    _weeklyCaloriesInt.toString(),
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.0,
                                    ),
                                  )
                                ],
                              ),
                            )),
                          )),
                    ),
                  ],
                )))
          ],
        ),
        Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                    child: Wrap(
                  spacing: 20,
                  runSpacing: 20.0,
                  children: <Widget>[
                    SizedBox(
                      width: 350.0,
                      height: 200.0,
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: const <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              Icon(
                                Icons.qr_code,
                                size: 60,
                              ),
                              Text(
                                "Last scanned product",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "Product Name",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.0,
                                ),
                              )
                            ],
                          ),
                        )),
                      ),
                    ),
                  ],
                )))
          ],
        ),
        Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                    child: Wrap(
                  spacing: 20,
                  runSpacing: 20.0,
                  children: <Widget>[
                    SizedBox(
                      width: 350.0,
                      height: 200.0,
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: const <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              Icon(
                                Icons.pie_chart,
                                size: 60,
                              ),
                              Text(
                                "Calories consumed today",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "1900/2400 calories",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0,
                                ),
                              )
                            ],
                          ),
                        )),
                      ),
                    ),
                  ],
                )))
          ],
        )
      ]));
    } else {
      return mainWidget;
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> scanBarcode() async {
      String barcodeScan;
      try {
        barcodeScan = await FlutterBarcodeScanner.scanBarcode(
            "#ff6666", "Cancel", false, ScanMode.BARCODE);
        if (barcodeScan != "" && barcodeScan != '-1') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailPage(barcode: barcodeScan)));
        }
      } on PlatformException {
        barcodeScan = "Failed to get platform version";
      }

      if (!mounted) return;
    }

    //to do: turn all of these views into actual pages

    return Scaffold(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountEmail: Text(_user.email!,
                    style: const TextStyle(fontFamily: "Poppins")),
                accountName: Text(_checkProfileName(),
                    style: const TextStyle(fontFamily: "Poppins")),
                currentAccountPicture: ClipOval(
                  child: Image(
                    image: NetworkImage(_checkPhotoURL()),
                  ),
                ),
                decoration: const BoxDecoration(color: Colors.black),
              ),
              ListTile(
                title: RichText(
                  text: const TextSpan(children: [
                    WidgetSpan(child: Icon(Icons.home, size: 22)),
                    TextSpan(
                        text: "Home",
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ))
                  ]),
                ),
                onTap: () {
                  setState(() {
                    mainWidget = null;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: RichText(
                  text: const TextSpan(children: [
                    WidgetSpan(child: Icon(Icons.history, size: 22)),
                    TextSpan(
                        text: "History",
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ))
                  ]),
                ),
                onTap: () {
                  setState(() {
                    mainWidget = const HistoryPage();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: RichText(
                  text: const TextSpan(children: [
                    WidgetSpan(child: Icon(Icons.lightbulb, size: 22)),
                    TextSpan(
                        text: "Tips",
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ))
                  ]),
                ),
                onTap: () {
                  setState(() {
                    mainWidget = const TipsPage();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: RichText(
                  text: const TextSpan(children: [
                    WidgetSpan(child: Icon(Icons.account_box, size: 22)),
                    TextSpan(
                        text: "Extra",
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ))
                  ]),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: RichText(
                  text: const TextSpan(children: [
                    WidgetSpan(child: Icon(Icons.settings, size: 22)),
                    TextSpan(
                        text: "Settings",
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ))
                  ]),
                ),
                onTap: () {
                  setState(() {
                    mainWidget = const SettingsPage();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: RichText(
                  text: const TextSpan(children: [
                    WidgetSpan(child: Icon(Icons.settings, size: 22)),
                    TextSpan(
                        text: "Sign Out",
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ))
                  ]),
                ),
                onTap: () async {
                  setState(() {
                    _isSigningOut = true;
                  });
                  await Authentication.signOut(context: context);
                  setState(() {
                    _isSigningOut = false;
                  });
                  Navigator.of(context).pushReplacement(_routeToLoginScreen());
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {scanBarcode()},
          child: const Icon(Icons.add_rounded, size: 40),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu)),
          ),
          title: const Text("Foodica",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
              )),
        ),
        //page needs to be scrollable so the body is wrapped in a SingleChildScrollView
        body: _buildHomeScreen());
  }
}
