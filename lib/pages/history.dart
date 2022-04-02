import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
                        width: 250.0,
                        height: 180.0,
                        child: Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      const SizedBox(height: 10.0),
                                      const Text("Product 1",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 30.0,
                                              fontWeight: FontWeight.w800)),
                                      const SizedBox(height: 10.0),
                                      Text("lorem ipsum lol",
                                          style: const TextStyle(
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
