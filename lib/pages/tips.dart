import 'package:flutter/material.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({Key key}) : super(key: key);

  @override 
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("Tips Page")
      )
    );
  }
}