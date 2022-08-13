import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class HistoryDetailPage extends StatefulWidget {
  const HistoryDetailPage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _HistoryDetailPageState createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  _renderBody() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Foodica",
            style:
                TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                  "Scan Details",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                )),
              ],
            ),
          )),
    );
  }
}
