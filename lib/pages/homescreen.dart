import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:Foodica/pages/add_food_manual.dart';
import 'package:Foodica/pages/calorie_detail.dart';
import 'package:Foodica/pages/history.dart';
import 'package:Foodica/pages/login.dart';
import 'package:Foodica/pages/productdetail.dart';
import 'package:Foodica/pages/settings.dart';
import 'package:Foodica/pages/tips.dart';
import 'package:Foodica/widgets/ActionButton.dart';
import 'package:Foodica/widgets/ExpandableFab.dart';
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
  late User _user;

  //i genuinely forgot how to easily concatenate strings in dart
  //so for now i just append 2 numbers in a string and return the value of that
  String? weeklyDisplayValue;
  String displayName = "";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Widget? mainWidget;
  bool codeIsScanned = false;
  Colors? navBackColor;
  String lastProductName = "";
  Color? bgColor;
  String allergen = "";

  late int? _weeklyCaloriesInt = 0;
  late int? _dailyCaloriesInt = 0;
  late int? _calorieGoalInt = 0;

  _checkIfWeeklyCaloriesIsNull() {
    _getCalorieGoal();
    if (_weeklyCaloriesInt == null) {
      return "0/" + _calorieGoalInt.toString() + " Kcal";
    } else {
      return _weeklyCaloriesInt.toString() + "/" + _calorieGoalInt.toString() + " Kcal";
    }
  }

  _checkIfDailyCaloriesIsNull() {
    _getCalorieGoal();
    if (_dailyCaloriesInt == null) {
      return "0/" + _calorieGoalInt.toString() + "Kcal";
    }
    else {
      return _dailyCaloriesInt.toString() + "/" + _calorieGoalInt.toString() + "Kcal";
    }
  }

  _checkIfLastScannedProductIsNull() {
    if (lastProductName == "") {
      return "None";
    }
    else {
      return lastProductName;
    }
  }

  @override

  void initState() {
    super.initState();
    _user = widget._user;
    _getWeeklyCalories();
    _getDailyCalories();
    _getLastScannedProduct();
    _getCalorieGoal();
    _reloadLocalStorage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getWeeklyCalories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _weeklyCaloriesInt = prefs.getInt("weekly");
    });
  }

  void _getDailyCalories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _dailyCaloriesInt = prefs.getInt("daily");
    });
  }

  void _getLastScannedProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lastProductName = prefs.getString("productname")!;
    });
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
        .pop(MaterialPageRoute(builder: (context) =>  HistoryPage(user: _user,)));
  }

  void navigateToSettings() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SettingsPage(user: _user)));
  }

  void navigateToTips() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TipsPage(user: _user)));
  }

  void navigateToAddFoodManual() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ManualFoodPage(user: _user)
    ));
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
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20.0),
          child: const Text("Today",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  fontSize: 45)),
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
                                  child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            const Icon(
                                              Icons.run_circle,
                                              size: 60,
                                            ),
                                            const Text(
                                              "Calories Consumed",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30.0),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              _checkIfDailyCaloriesIsNull(),
                                              style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20.0,
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CalorieDetailPage(user: _user))),
                                ),
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
                              child: Card(
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const Icon(
                                            Icons.qr_code,
                                            size: 60,
                                          ),
                                          const Text(
                                            "Last scanned product",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25.0),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            _checkIfLastScannedProductIsNull(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
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
                          child: InkWell(
                            onTap: () {

                            },
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
                                    _checkIfWeeklyCaloriesIsNull(),
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
                  builder: (context) => DetailPage(barcode: barcodeScan, user: _user, isFromScan: true,)));
        }
      } on PlatformException {
        barcodeScan = "Failed to get platform version";
      }

      if (!mounted) return;
    }

    _setNavTextColor() {
      var brightness = MediaQuery.of(context).platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;

      if (isDarkMode) {
        return Colors.white;
      } else {
        return Colors.black;
      }
    }


    return Scaffold(
        drawer: Drawer(
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
                    child: CachedNetworkImage(
                  imageUrl: _checkPhotoURL(),
                )),
                decoration: const BoxDecoration(color: Colors.black),
              ),
              ListTile(
                title: RichText(
                  text: TextSpan(children: [
                    const WidgetSpan(child: Icon(Icons.home, size: 22)),
                    TextSpan(
                        text: "Home",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: _setNavTextColor(),
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
                  text: TextSpan(children: [
                    const WidgetSpan(child: Icon(Icons.history, size: 22)),
                    TextSpan(
                        text: "History",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: _setNavTextColor(),
                        ))
                  ]),
                ),
                onTap: () {
                  setState(() {
                    mainWidget = HistoryPage(user: _user);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: RichText(
                  text: TextSpan(children: [
                    const WidgetSpan(child: Icon(Icons.lightbulb, size: 22)),
                    TextSpan(
                        text: "Tips",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: _setNavTextColor(),
                        ))
                  ]),
                ),
                onTap: () {
                  setState(() {
                    mainWidget = TipsPage(user: _user);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: RichText(
                  text: TextSpan(children: [
                    const WidgetSpan(child: Icon(Icons.pie_chart, size: 22)),
                    TextSpan(
                        text: "Calorie Details",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: _setNavTextColor(),
                        ))
                  ]),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  setState(() {
                    mainWidget = CalorieDetailPage(user: _user);
                  });
                  Navigator.pop(context);
                },
              ),


              ListTile(
                title: RichText(
                  text: TextSpan(children: [
                    const WidgetSpan(child: Icon(Icons.settings, size: 22)),
                    TextSpan(
                        text: "Settings",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: _setNavTextColor(),
                        ))
                  ]),
                ),
                onTap: () {
                  setState(() {
                    mainWidget = SettingsPage(user: _user);
                  });
                  Navigator.pop(context);
                },
              ),

            ],
          ),
        ),
        floatingActionButton: ExpandableFab(
          distance: 112.0,
          children: [
            ActionButton(icon: const Icon(Icons.qr_code), onPressed: () => scanBarcode(),),
            ActionButton(icon: const Icon(Icons.create), onPressed: () => {
              navigateToAddFoodManual()
            },)
          ]
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => {scanBarcode()},
        //   child: const Icon(Icons.add_rounded, size: 40),
        // ),
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
