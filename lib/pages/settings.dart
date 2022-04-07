import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSwitched = false;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    RxBool _isLightTheme = false.obs;
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
                  title: const Text("Allergens",
                      style: TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.bold)),
                  value: Text("Possible allergens",
                      style: TextStyle(
                          fontFamily: "Poppins", fontWeight: FontWeight.w500)),
                ),
                SettingsTile.switchTile(
                    initialValue: _isSwitched,
                    onToggle: (value) {
                      if (Get.isDarkMode) {
                        debugPrint(Get.isDarkMode.toString());
                        Get.changeTheme(ThemeData.dark());
                        debugPrint("Test");
                        setState(() {
                          _isSwitched = true;
                        });
                      } else {
                        debugPrint(Get.isDarkMode.toString());
                        Get.changeTheme(ThemeData.light());
                        debugPrint("Test2");
                        setState(() {
                          _isSwitched = false;
                        });
                      }
                    },
                    onPressed: (context) {},
                    title: const Text("Dark Theme",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold)),
                    leading: const Icon(Icons.wb_sunny))
              ]),
          SettingsSection(
              title: const Text("About",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
              tiles: [
                SettingsTile.navigation(
                    leading: const Icon(Icons.info),
                    title: const Text("App Version",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold)),
                    description: const Text("v2.0.0"))
              ])
        ]),
      ],
    ));
  }
}
