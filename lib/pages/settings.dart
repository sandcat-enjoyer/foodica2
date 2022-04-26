import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numberpicker/numberpicker.dart';

import '../utils/authentication.dart';
import 'login.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSwitched = false;
  bool value = false;
  bool gluten = false;
  bool eggs = false;
  bool milk = false;
  bool peanuts = false;
  bool soy = false;
  bool _isSigningOut = false;

  @override
  void initState() {
    super.initState();
    _getWeeklyCalorieGoal();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int? _weeklyCaloriesGoalInt = 0;

  _getWeeklyCalorieGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _weeklyCaloriesGoalInt = prefs.getInt("goal");
    });
  }

  _checkIfWeeklyCaloriesIsNull() {
    if (_weeklyCaloriesGoalInt == null) {
      return "No calorie goal set";
    } else {
      return _weeklyCaloriesGoalInt.toString() + " calories";
    }
  }

  _nullCheckNumPicker() {
    if (_weeklyCaloriesGoalInt == null) {
      return 2400; //give a random value instead of 0 to avoid null errors,
      // doesn't really matter in the picker anyway
    } else {
      return _weeklyCaloriesGoalInt;
    }
  }

  _deleteProductHistory() {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              20.0
            )
          )
        ),
        title: Text("Delete Product History",
        style: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold
        )),
        content: Container(
          width: 400,
          child: Text("Are you sure you want to wipe your product history? This action can't be undone.",
          style: TextStyle(
            fontFamily: "Poppins"
          ))
        ),
        actions: [
          TextButton(
            onPressed: () {

            },
            child: Text("Delete",
            style: TextStyle(
              fontFamily: "Poppins"
            ))
          ),
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("Cancel",
          style: TextStyle(
            fontFamily: "Poppins"
          )))
        ],
      );
    });
  }

  _showCalorieGoalPicker() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            title: Text("Calorie Goal",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold
            )),
            content: StatefulBuilder(
              builder: (context, SBsetState) {
                return  NumberPicker(
                        maxValue: 9900,
                        minValue: 0,
                        itemHeight: 100,
                        haptics: true,
                        textStyle: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                        value: _nullCheckNumPicker(),
                        onChanged: (value) {
                          setState(() => _weeklyCaloriesGoalInt = value);
                          SBsetState(() => _weeklyCaloriesGoalInt = value);
                        },
                        step: 100);
              },
            ),
              actions: [
              TextButton(
              onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt("goal", _weeklyCaloriesGoalInt!);
            Navigator.pop(context);
          },
          child: Text("Done",
          style: TextStyle(
            fontFamily: "Poppins"
          )))
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
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            title: Text("Select allergens",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            content: StatefulBuilder(
              builder: (context, SBsetState) {
                return Container(
                  width: 400,
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CheckboxListTile(
                              value: this.gluten,
                              title: Text("Gluten",
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
                              title: Text("Eggs",
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
                              title: Text("Milk",
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
                              title: Text("Peanuts",
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
                              title: Text("Soy",
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
              }
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Done")
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        SettingsList(sections: [
          SettingsSection(
              title: const Text("Settings",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold)),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.food_bank),
                  onPressed: (value) {
                    _showAllergensMenu();
                  },
                  title: const Text("Allergens",
                      style: TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.bold)),
                  value: Text("Possible allergens",
                      style: TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.w500)),
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.food_bank),
                  onPressed: (value) {
                    _showCalorieGoalPicker();
                  },
                  title: const Text("Set Calorie Goal",
                      style: TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.bold)),
                  value: Text(
                      "Set your weekly calorie goal. Current goal: " +
                          _checkIfWeeklyCaloriesIsNull(),
                      style: TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.w500)),
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.delete_forever),
                  onPressed: (value) {
                    _deleteProductHistory();
                  },
                  title: const Text("Delete History",
                      style: TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.bold)),
                  value: Text("Delete all products from your history",
                      style: TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.w500)),
                ),
                SettingsTile.navigation(
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
              title: const Text("About",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0)),
              tiles: [
                SettingsTile(
                    leading: const Icon(Icons.info),
                    title: const Text("App Version",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold)),
                    description: const Text("v1.0.0"))
              ])
        ]),
      ],
    ));
  }
}
