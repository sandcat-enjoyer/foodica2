import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:Foodica/pages/add_food_manual.dart';
import 'package:Foodica/pages/calorie_detail.dart';
import 'package:Foodica/pages/history.dart';
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
  String? weeklyDisplayValue;
  String displayName = "";
  Widget? mainWidget;
  bool codeIsScanned = false;
  Colors? navBackColor;
  String lastProductName = "";
  Color? bgColor;
  String allergen = "";
  String? today;
  BouncingScrollPhysics bouncingScrollPhysics = BouncingScrollPhysics();

  final DateFormat formatter = DateFormat("dd/mm/yyyy");

  int? _weeklyCaloriesInt;
  int? _dailyCaloriesInt;
  int? _calorieGoalInt;

  _checkIfWeeklyCaloriesIsNull() {
    _getWeeklyCalories();
    _getCalorieGoal();
    if (_weeklyCaloriesInt == null) {
      return "No Calories Consumed";
    } else {
      return _weeklyCaloriesInt.toString() + " Kcal";
    }
  }

  _determineIfOnHomeScreen() {
    if (mainWidget == null) {
      return ExpandableFab(distance: 112.0, children: [
        ActionButton(
          icon: const Icon(Icons.qr_code),
          onPressed: () => scanBarcode(),
        ),
        ActionButton(
          icon: const Icon(Icons.create),
          onPressed: () => {navigateToAddFoodManual()},
        )
      ]);
    } else {
      return null;
    }
  }

  _checkIfDailyCaloriesIsNull() {
    _getDailyCalories();
    _getCalorieGoal();
    if (_dailyCaloriesInt == null) {
      return "0/" + _calorieGoalInt.toString() + "Kcal";
    } else {
      return _dailyCaloriesInt.toString() +
          "/" +
          _calorieGoalInt.toString() +
          "Kcal";
    }
  }

  _checkIfLastScannedProductIsNull() {
    if (lastProductName == "") {
      return "None";
    } else {
      return lastProductName;
    }
  }

  @override
  void initState() {
    super.initState();
    _user = widget._user;
    setState(() {
      today = formatter.format(DateTime.now());
    });
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
    await prefs.reload();
    setState(() {
      _weeklyCaloriesInt = prefs.getInt("weekly");
    });
  }

  void _getDailyCalories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    setState(() {
      _dailyCaloriesInt = prefs.getInt("daily");
    });
  }

  void _getLastScannedProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    setState(() {
      if (prefs.getString("productname") == null) {
        lastProductName = "";
      } else {
        lastProductName = prefs.getString("productname")!;
      }
    });
  }

  void _getCalorieGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _calorieGoalInt = prefs.getInt("goal");
  }

  void _reloadLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
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

  Future<void> scanBarcode() async {
    String barcodeScan;
    try {
      barcodeScan = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", false, ScanMode.BARCODE);
      if (barcodeScan != "" && barcodeScan != '-1') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(
                      barcode: barcodeScan,
                      user: _user,
                      isFromScan: true,
                    )));
      }
    } on PlatformException {
      barcodeScan = "Failed to get platform version";
    }

    if (!mounted) return;
  }

  void navigateToHistory() {
    Navigator.of(context).pop(MaterialPageRoute(
        builder: (context) => HistoryPage(
              user: _user,
            )));
  }

  void navigateToSettings() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SettingsPage(user: _user)));
  }

  void navigateToTips() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => TipsPage(user: _user)));
  }

  void navigateToAddFoodManual() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ManualFoodPage(user: _user)));
  }

  Widget? _buildHomeScreen() {
    if (mainWidget == null) {
      return ListView(
        physics: bouncingScrollPhysics,
        children: [
          Column(
            children: [
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
                                        "Daily Calories",
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
                                      "Last Scanned Product",
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
                                  onTap: () {},
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
            ],
          )
        ],
      );
    } else {
      return mainWidget;
    }
  }

  @override
  Widget build(BuildContext context) {
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
        floatingActionButton: _determineIfOnHomeScreen(),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            physics: bouncingScrollPhysics,
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
        body: _buildHomeScreen());
  }
}
