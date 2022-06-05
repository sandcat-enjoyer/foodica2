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
            allergens = prefs.getStringList("allergens")!;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(shrinkWrap: true, children: [
      Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Text("Tips",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                    fontSize: 35)),
          ),
          const SizedBox(height: 8.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: allergens.length,
            itemBuilder: (context, index) {
              return Column(
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
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  SizedBox(height: 10)
                ],
              );
            },
          ),
        ],
      )
    ]));
  }
}
