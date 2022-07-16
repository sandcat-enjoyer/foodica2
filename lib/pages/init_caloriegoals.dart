import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Foodica/pages/homescreen.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitCalorieGoal extends StatefulWidget {
  const InitCalorieGoal({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _InitCalorieGoalState createState() => _InitCalorieGoalState();
}

class _InitCalorieGoalState extends State<InitCalorieGoal> {
  late User user;

  int calorieGoalDaily = 0;
  @override
  void initState() {
    super.initState();
    user = widget._user;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _returnNumberPicker() {
    return Column(
      children: [
        NumberPicker(
          value: calorieGoalDaily,
          minValue: 0,
          maxValue: 9900,
          step: 50,
          axis: Axis.horizontal,
          haptics: true,
          onChanged: (value) => setState(() => calorieGoalDaily = value),
        ),
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => setState(() {
                final newValue = calorieGoalDaily - 10;
                calorieGoalDaily = newValue.clamp(0, 9900);
              }),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => setState(() {
                final newValue = calorieGoalDaily + 20;
                calorieGoalDaily = newValue.clamp(0, 9900);
              }),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20.0),
          child: Column(children: [
            const SizedBox(height: 40),
            Image.asset(
              "assets/splash_icon.png",
              width: 120,
            ),
            Container(
              alignment: Alignment.center,
              child: const Center(
                  child: Text("Determine your daily calorie goal",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ))),
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              child: const Text(
                  "The recommended daily calorie intake is: \n"
                  "- 2,000 calories for women \n"
                  "- 2,600 calories for men",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                  )),
            ),
            const SizedBox(height: 30.0),
            Container(
                alignment: Alignment.center,
                child: const Text("Daily Calories",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 25,
                        fontWeight: FontWeight.w600))),
            Container(
                alignment: Alignment.center,
                child: Text(calorieGoalDaily.toString() + "\nKcal",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "Poppins", fontSize: 25))),
            StatefulBuilder(
              builder: (BuildContext context, SBsetState) {
                return _returnNumberPicker();
              },
            ),
            Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.redAccent)),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setInt("goal", calorieGoalDaily);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreenPage(user: user)));
                    },
                    child: const Text("Save Calorie Goal")))
          ])),
    ));
  }
}
