import "package:flutter/material.dart";

class CalorieDetailPage extends StatefulWidget {
  const CalorieDetailPage({Key? key}) : super(key: key);

  @override
  _CalorieDetailPageState createState() => _CalorieDetailPageState();
}

class _CalorieDetailPageState extends State<CalorieDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text("Calorie Details"),
    ));
  }
}
