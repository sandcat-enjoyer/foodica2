import 'package:Foodica/pages/tips_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "../utils/string_extension.dart";

class TipsPage extends StatefulWidget {
  const TipsPage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  late User user;
  List<String> allergens = [];

  _getAllergens() {
    SharedPreferences.getInstance().then((prefs) => {
          setState(() {
            allergens = prefs.getStringList("allergens") ?? [];
          })
        });
  }

  @override
  void initState() {
    _getAllergens();
    super.initState();
    user = widget._user;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _checkSystemThemeMode() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    if (isDarkMode) {
      return Color.fromARGB(255, 66, 66, 66);
    } else {
      return Colors.white70;
    }
  }

  _checkIfNoAllergensSelected() {
    if (allergens.isEmpty) {
      return Column(
        children: [
          Icon(Icons.warning, color: Colors.yellow, size: 96),
          Text("No allergens selected",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  fontSize: 30)),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Select allergens in the Settings menu if you wish to view any tips.",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: "Poppins", fontSize: 18),
            ),
          ),
        ],
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: allergens.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TipsDetailPage(
                              user: user, allergen: allergens[index])));
                    },
                    title: Text(allergens[index].capitalize(),
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    subtitle: Text("Tips for " + allergens[index] + " allergy"),
                    tileColor: _checkSystemThemeMode(),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 0.01),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  SizedBox(height: 10)
                ],
              ));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(shrinkWrap: true, children: [
      Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15.0),
            child: Text("Tips",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                    fontSize: 35)),
          ),
          _checkIfNoAllergensSelected()
        ],
      )
    ]));
  }
}
