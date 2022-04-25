import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/Product.dart';

import '../models/product.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key, required User user}) : _user = user, super(key: key);

  final User _user;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late User user;
  List<Product> productList = [];
  var products = {};
  _getHistoryFromFirebase() async {
    final ref = FirebaseDatabase(
            databaseURL:
                "https://foodica-9743c-default-rtdb.europe-west1.firebasedatabase.app")
        .ref();
    final snapshot = await ref.child("products/").onChildAdded.forEach((event) {
      print(event.snapshot.key! + ": " + event.snapshot.value.toString());
      print(event.snapshot.key!);
      products[event.snapshot.key!] = event.snapshot.value.toString();
      print(event.snapshot.value);
    });

    if (snapshot.exists) {
      // print(snapshot.value);
    } else {
      print("No data found?");
    }
  }

  @override
  void initState() {
    super.initState();
    _getHistoryFromFirebase();
    print(products.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20.0),
          child: const Text("History",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  fontSize: 35)),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20.0,
                  children: <Widget>[
                    SizedBox(
                        width: 300.0,
                        height: 180.0,
                        child: Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: const <Widget>[
                                      SizedBox(height: 10.0),
                                      Text("Product 1",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 30.0,
                                              fontWeight: FontWeight.w800)),
                                      SizedBox(height: 10.0),
                                      Text("lorem ipsum lol",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600))
                                    ],
                                  ))),
                        ))
                  ],
                ),
              ),
            )
          ],
        )
      ],
    )));
  }
}
