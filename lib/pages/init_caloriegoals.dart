import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class InitCalorieGoal extends StatefulWidget {
  const InitCalorieGoal({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _InitCalorieGoalState createState() => _InitCalorieGoalState();
}

class _InitCalorieGoalState extends State<InitCalorieGoal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int calorieGoalWeekly = 0;
    int calorieGoalDaily = 0;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20.0),
          child: Column(children: [
            SizedBox(height: 90),
            Image.asset(
              "assets/splash_icon.png",
              width: 120,
            ),
            const Center(
                child: Text("Select your calorie goals",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ))),
            const SizedBox(height: 30.0),
            Container(
                alignment: Alignment.center,
                child: Text("Daily Calories",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 25,
                        fontWeight: FontWeight.w600))),
            Container(
                alignment: Alignment.center,
                child: Text(calorieGoalDaily.toString() + "\nKcal",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "Poppins", fontSize: 25))),
            Container(child: StatefulBuilder(
              builder: (BuildContext context, SBsetState) {
                return NumberPicker(
                    value: calorieGoalDaily,
                    minValue: 0,
                    maxValue: 9900,
                    haptics: true,
                    step: 100,
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        calorieGoalDaily = value;
                      });
                      SBsetState(() => calorieGoalDaily = value);
                    });
              },
            ))
          ])),
    ));
  }
}
