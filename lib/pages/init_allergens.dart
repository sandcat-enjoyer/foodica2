import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homescreen.dart';
import 'init_caloriegoals.dart';

class InitAllergens extends StatefulWidget {
  const InitAllergens({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;
  _InitAllergensState createState() => _InitAllergensState();
}

class _InitAllergensState extends State<InitAllergens> {
  bool gluten = false;
  bool eggs = false;
  bool milk = false;
  bool peanuts = false;
  bool soy = false;

  late User user;

  String allergen = "";
  List<String> allergens = [];

  int? calorieGoal;

  @override
  void initState() {
    super.initState();
    user = widget._user;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 90),
                    Image.asset(
                      "assets/splash_icon.png",
                      width: 120,
                    ),
                    const Center(
                      child: Text("Select any allergens you might experience",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    const SizedBox(height: 30.0),
                    CheckboxListTile(
                        value: gluten,
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
                        }),
                    CheckboxListTile(
                        value: eggs,
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
                        }),
                    CheckboxListTile(
                        value: milk,
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
                        }),
                    SizedBox(height: 100.0),
                    TextButton(
                        onPressed: () async {
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
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            calorieGoal = prefs.getInt("goal");
                          });
                          if (calorieGoal == null) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        InitCalorieGoal(user: user)));
                          } else {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeScreenPage(user: user)));
                          }
                        },
                        child: const Text("Done",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.bold)))
                  ],
                ))));
  }
}
