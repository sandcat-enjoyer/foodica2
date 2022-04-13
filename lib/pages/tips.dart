import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({Key? key, required User user, required String allergen})
      : _user = user,
        _allergen = allergen,
        super(key: key);

  final User _user;
  final String _allergen;
  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  late User _user;
  String allergen = "";

  _determineTips(String allergen) {
    switch (allergen) {
      case "gluten":
        Text("This is where gluten tips will be");
        break;
      case "eggs":
        Text("This is where egg allergy tips will be");
        break;
      case "soy":
        Text("This is where soy allergy tips will be");
        break;
      case "eggs":
        Text("This is where egg allergy tips will be");
        break;
      case "peanuts":
        Text("This is where peanut allergy tips will be");
        break;
      default:
        Text("Emmm 😜 That's a litol silly aheehee 📲😂😂😂");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20.0),
          child: const Text("Tips",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  fontSize: 35)),
        ),
        const SizedBox(height: 8.0),
        Card(
            child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "assets/drawer-header.jpg",
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                    child: Column(
                  children: [
                    Text("This is a title",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                    Text("Subtitle",
                        style: TextStyle(fontFamily: "Poppins", fontSize: 16))
                  ],
                ))),
          ],
        )),
        _determineTips(allergen),
      ],
    )));
  }
}
