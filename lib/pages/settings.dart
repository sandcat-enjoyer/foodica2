import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
        builder: (context) {
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
            content: Container(
              height: 400,
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
                          }),
                    ],
                  )),
            ),
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
                  leading: const Icon(Icons.delete_forever),
                  onPressed: (value) {
                    _showAllergensMenu();
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
