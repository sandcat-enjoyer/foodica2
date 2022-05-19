import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

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

  _determineAllergenToSave() {
    //this still needs to be adjusted for multiple allergens but for now just one
    //so this code kinda sucks and isn't very pretty lol
    if (gluten == true) {
      setState(() {
        allergen = "gluten";
      });
    }
    else if (eggs == true) {
      setState(() {
        allergen = "eggs";
      });
    }

    else if (milk == true) {
      setState(() {
        allergen = "milk";
      });
    }
    else if (peanuts == true) {
      setState(() {
        allergen = "peanuts";
      });
    }
    else if (soy == true) {
      setState(() {
        allergen = "soy";
      });
    }
    _saveAllergenToMemory();
  }

  _saveAllergenToMemory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("allergen", allergen);
    print(prefs.getString("allergen"));
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
                          _determineAllergenToSave();
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          setState(() {
                            calorieGoal = prefs.getInt("goal");
                          });
                          print(calorieGoal);
                          if (calorieGoal == null) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    InitCalorieGoal(user: user)));
                          }
                          else {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreenPage(user: user)));
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
