import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../utils/authentication.dart';
import 'login.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool value = false;
  bool gluten = false;
  bool eggs = false;
  bool milk = false;
  bool peanuts = false;
  bool soy = false;
  String version = "";
  bool _isSigningOut = false;
  late User user;

  final databaseReference = FirebaseDatabase(
          databaseURL:
              "https://foodica-9743c-default-rtdb.europe-west1.firebasedatabase.app")
      .ref();

  @override
  void initState() {
    super.initState();
    _getVersionNumber();
    user = widget._user;
    allergens.clear();
    _getAllergens();
    _getDailyCalorieGoal();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  _getAllergens() {
    SharedPreferences.getInstance().then((prefs) => {
          allergens = prefs.getStringList("allergens")!,
          if (allergens.contains("gluten"))
            {
              setState(() {
                gluten = true;
              })
            },
          if (allergens.contains("eggs"))
            {
              setState(() {
                eggs = true;
              })
            },
          if (allergens.contains("soy"))
            {
              setState(() {
                soy = true;
              })
            },
          if (allergens.contains("milk"))
            {
              setState(() {
                milk = true;
              })
            },
          if (allergens.contains("peanuts"))
            {
              setState(() {
                peanuts = true;
              })
            }
        });
  }

  List<String> allergens = [];

  _checkWhichAllergensSelected() {
    allergens.forEach((element) {
      if (element.contains("gluten")) {
        gluten = true;
      }
      if (element.contains("eggs")) {
        eggs = true;
      }
      if (element.contains("milk")) {
        milk = true;
      }
      if (element.contains("peanuts")) {
        peanuts = true;
      }
      if (element.contains("soy")) {
        soy = true;
      }
    });
  }

  int? _dailyCaloriesGoalInt = 0;

  _getDailyCalorieGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _dailyCaloriesGoalInt = prefs.getInt("goal");
    });
  }

  _checkIfDailyCaloriesIsNull() {
    if (_dailyCaloriesGoalInt == 0) {
      return "No calorie goal set";
    } else {
      return _dailyCaloriesGoalInt.toString() + " calories";
    }
  }

  _nullCheckNumPicker() {
    if (_dailyCaloriesGoalInt == null) {
      return 2400; //give a random value instead of 0 to avoid null errors,
      // doesn't really matter in the picker anyway
    } else {
      return _dailyCaloriesGoalInt;
    }
  }

  _deleteProductHistory() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text("Delete Product History",
                style: TextStyle(
                    fontFamily: "Poppins", fontWeight: FontWeight.bold)),
            content: const SizedBox(
                width: 400,
                child: Text(
                    "Are you sure you want to wipe your product history? This action can't be undone.",
                    style: TextStyle(fontFamily: "Poppins"))),
            actions: [
              TextButton(
                  onPressed: () {
                    databaseReference
                        .child("users/" + user.uid + "/products")
                        .remove()
                        .then((value) => {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("History Deleted"))),
                              Navigator.of(context).pop()
                            });
                  },
                  child: const Text("Delete",
                      style: TextStyle(fontFamily: "Poppins"))),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel",
                      style: TextStyle(fontFamily: "Poppins")))
            ],
          );
        });
  }

  _showCalorieGoalPicker() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            title: const Text("Calorie Goal",
                style: TextStyle(
                    fontFamily: "Poppins", fontWeight: FontWeight.bold)),
            content: StatefulBuilder(
              builder: (context, SBsetState) {
                return NumberPicker(
                    maxValue: 9900,
                    minValue: 0,
                    itemHeight: 100,
                    haptics: true,
                    textStyle: const TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                    value: _nullCheckNumPicker(),
                    onChanged: (value) {
                      setState(() => _dailyCaloriesGoalInt = value);
                      SBsetState(() => _dailyCaloriesGoalInt = value);
                    },
                    step: 100);
              },
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt("goal", _dailyCaloriesGoalInt!);
                    Navigator.pop(context);
                  },
                  child: const Text("Done",
                      style: TextStyle(fontFamily: "Poppins")))
            ],
          );
        });
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

  _showAllergensMenu() {
    _checkWhichAllergensSelected();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.all(10.0),
            title: const Text("Select allergens",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            content: StatefulBuilder(builder: (context, SBsetState) {
              return SizedBox(
                width: 400,
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CheckboxListTile(
                            value: this.gluten,
                            title: const Text("Gluten",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                )),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? gluten) {
                              setState(() {
                                this.gluten = gluten!;
                              });
                              SBsetState(() => this.gluten = gluten!);
                            }),
                        CheckboxListTile(
                            value: this.eggs,
                            title: const Text("Eggs",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                )),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? eggs) {
                              setState(() {
                                this.eggs = eggs!;
                              });
                              SBsetState(() => this.eggs = eggs!);
                            }),
                        CheckboxListTile(
                            value: this.milk,
                            title: const Text("Milk",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                )),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? milk) {
                              setState(() {
                                this.milk = milk!;
                              });
                              SBsetState(() => this.milk = milk!);
                            }),
                        CheckboxListTile(
                            value: this.peanuts,
                            title: const Text("Peanuts",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                )),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? peanuts) {
                              setState(() {
                                this.peanuts = peanuts!;
                              });
                              SBsetState(() => this.peanuts = peanuts!);
                            }),
                        CheckboxListTile(
                            value: this.soy,
                            title: const Text("Soy",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                )),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? soy) {
                              setState(() {
                                this.soy = soy!;
                              });
                              SBsetState(() => this.soy = soy!);
                            }),
                      ],
                    )),
              );
            }),
            actions: [
              TextButton(
                  onPressed: () async {
                    allergens.clear();
                    if (gluten == true) {
                      allergens.add("gluten");
                    }
                    if (milk == true) {
                      allergens.add("milk");
                    }
                    if (eggs == true) {
                      allergens.add("eggs");
                    }
                    if (soy == true) {
                      allergens.add("soy");
                    }
                    if (peanuts == true) {
                      allergens.add("peanuts");
                    }
                    SharedPreferences.getInstance().then((prefs) =>
                        {prefs.setStringList("allergens", allergens)});
                    Navigator.pop(context);
                  },
                  child: const Text("Done"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _setThemeTextColor() {
      var brightness = MediaQuery.of(context).platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;

      if (isDarkMode) {
        return Colors.white;
      } else {
        return Colors.black;
      }
    }

    return Scaffold(
        body: Row(
      children: [
        SettingsList(physics: BouncingScrollPhysics(), sections: [
          SettingsSection(
              title: Text("Settings",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: _setThemeTextColor(),
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold)),
              tiles: <SettingsTile>[
                SettingsTile(
                  leading: const Icon(Icons.food_bank),
                  onPressed: (value) {
                    _showAllergensMenu();
                  },
                  title: const Text("Allergens",
                      style: TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.bold)),
                  value: const Text("Possible allergens",
                      style: TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.w500)),
                ),
                SettingsTile(
                  leading: const Icon(Icons.run_circle_outlined),
                  onPressed: (value) {
                    _showCalorieGoalPicker();
                  },
                  title: const Text("Set Calorie Goal",
                      style: TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.bold)),
                  value: Text(
                      "Current goal: \n" + _checkIfDailyCaloriesIsNull(),
                      style: const TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.w500)),
                ),
                SettingsTile(
                  leading: const Icon(Icons.delete_forever),
                  onPressed: (value) {
                    _deleteProductHistory();
                  },
                  title: const Text("Delete History",
                      style: TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.bold)),
                  value: const Text("Clear product history",
                      style: TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.w500)),
                ),
                SettingsTile(
                  leading: const Icon(Icons.logout_outlined),
                  onPressed: (value) async {
                    setState(() {
                      _isSigningOut = true;
                    });
                    await Authentication.signOut(context: context);
                    setState(() {
                      _isSigningOut = false;
                    });
                    Navigator.of(context)
                        .pushReplacement(_routeToLoginScreen());
                  },
                  title: const Text("Sign Out",
                      style: TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.bold)),
                ),
              ]),
          SettingsSection(
              title: Text("About",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: _setThemeTextColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0)),
              tiles: [
                SettingsTile(
                    leading: const Icon(Icons.info),
                    title: const Text("App Version",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold)),
                    description: Text(version))
              ])
        ]),
      ],
    ));
  }
}
